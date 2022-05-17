#!/bin/bash
read -p $'Model type:\n[1] Random Decision Forest\n[2] Neural Network\n>> ' model_type
training_script="train_hrv_RDF_classification_model.py"
model_folder_name=RDF_HRVClassificationModel
case "$model_type" in
    1) training_script="train_hrv_RDF_classification_model.py"
        model_folder_name="RDF_HRVClassificationModel"
    ;;
    2) training_script="train_hrv_NN_classification_model.py"
        model_folder_name="NN_HRVClassificationModel"
    ;;
esac
START=$(($(ls | rg -NoP "'$model_folder_name'\K\d+" | sort -t= -nr | head -1)+1))
printf "$START"

[[ ! -z $1 ]] && END=$((START+$1)) || END=$((START+10))
for (( i=$START; i<=$END; i++ ))
do
    python3 $training_script $model_folder_name-$i > training_output$i.txt &&
    sed -i 's/^H//g; s/\r/\n/g' training_output$i.txt
    rg -NoP '^accuracy:\K.*' training_output$1.txt
    mv training_output$i.txt $model_folder_name-$i
done
