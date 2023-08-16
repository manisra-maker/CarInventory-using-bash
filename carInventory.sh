choice=0
function displayStuff {
    #echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
    echo
    echo "Welcome to this carInventory.sh program"
    echo
    echo "Select Among the following options"
    echo
    echo -e "1.ADD DATA\n2.UPDATE\n3.DELETE\n4.SHOW\n5.SEARCH\n6.EXIT"
    echo
    read -p "Enter your choice :" choice
    echo "option entered $choice"
    if [ $choice -eq 1 ]; then
        echo "adding"
        addingCar
    elif [ $choice -eq 2 ]; then
        echo "updating record ..."
        updateCar
    elif [ $choice -eq 3 ]; then
        echo "deleting records ..."
        deletingCar
    elif [ $choice -eq 4 ]; then
        echo "showing records ..."
        showCars
    elif [ $choice -eq 5 ]; then
        echo "Searching records..."
        searchCar
    elif [ $choice -eq 6 ]; then
        echo "exiting..."
        EXIT
    fi
}
function updateCar {
    echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
    read -p "Enter your phone-no :" phone_no
    echo
    echo "Phone no entered was : $phone_no"
    echo
    car_info=$(grep "$phone_no" carinfo.csv)
    if [ -z "$car_info" ]; then
        echo "No cars found for this phone number."
        echo
        echo "Returning to the main menu..."
        echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
        displayStuff
    fi
    echo "Cars owned by $phone_no are : "
    IFS=$'\n' read -rd '' -a car_entries <<<"$car_info"
    param_names=("car_make" "car_model" "owner_name" "mobile_no" "reg_no")
    echo "---------------------"
    for car_entry in "${car_entries[@]}"; do
        IFS=',' read -ra elements <<<"$car_entry"
        for i in "${!elements[@]}"; do
            echo "${param_names[i]}: ${elements[i]}"
        done
        echo "---------------------"
    done
    echo
    read -p "Enter the car's reg_no to update car details : " reg_no
    echo
    record_to_update=$(grep "$reg_no" carinfo.csv)
    echo -e "$record_to_update\n\n"
    read -p "Are you sure you want to update this record ? (yes/no) :" choice
    clean_record=$(echo "$record_to_update" | tr ',' ' ')
    # Store cleaned values in an array
    read -ra array_update <<<"$clean_record"
    echo -e "Enter the number to select the option to update\n1.Make\n2.Model\n3.OwnerName\n4.mobile number\n5.reg_no\n"
    read -p "Enter your choice :" choice
    read -p "Replace ${array_update[$choice - 1]} with: " replacement
    array_update[$choice - 1]=$replacement
    echo ${array_update[*]}
    echo -e "Your updated details are :\n"
    # Join the array elements back into a line with commas
    updated_line=$(
        IFS=','
        echo "${array_update[*]}"
    )
    # Replace the original line with the updated line in the file
    sed -i "s|$record_to_update|$updated_line|" carinfo.csv
    echo
    echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
    displayStuff
}
function addingCar {
    echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
    echo
    carregex='^[A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]{4}$'
    read -p "Enter Make :" car_make
    echo
    read -p "Enter Model :" car_model
    echo
    read -p "Enter Owner Name :" own_name # should be characters only
    echo
    read -p "Enter Mobile no :" mobileno # should be numbers only
    echo
    read -p "Enter reg.no :" reg_no # should be alpha numberic
    echo
    #echo >>carinfo.txt
    if [[ $reg_no =~ $carregex && $mobileno =~ ^[0-9]{10}$ ]]; then # correct credentials regex check
        if grep -n "$reg_no" carinfo.csv; then
            echo -e "\nCar $reg_no owned by $own_name is already present in this db\n"
            read -p "Would you like to modify details ? (yes/no) : " choice
            if [ $choice == "yes" ]; then
                updateCar
            fi
        else
            echo "$car_make,$car_model,$own_name,$mobileno,$reg_no" >>carinfo.csv
            echo
            echo -e "Car $reg_no Owned by $own_name was added to the DB\n"
            echo
            echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
            displayStuff
        fi
    else
        echo
        echo -e "Credentials incorrect re-enter details\n"
        echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
        displayStuff
    fi
}
function deletingCar {
    carregex='^[A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]{4}$'
    echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
    read -p "Enter your phone-no :" phone_no
    echo
    echo "Phone no entered was : $phone_no"
    echo
    car_info=$(grep "$phone_no" carinfo.csv)
    if [ -z "$car_info" ]; then
        echo "No cars found for this phone number."
        echo
        echo "Returning to the main menu..."
        echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
        displayStuff
    fi
    echo "Cars owned by $phone_no are : "
    IFS=$'\n' read -rd '' -a car_entries <<<"$car_info"
    param_names=("car_make" "car_model" "owner_name" "mobile_no" "reg_no")
    echo "---------------------"
    for car_entry in "${car_entries[@]}"; do
        IFS=',' read -ra elements <<<"$car_entry"
        for i in "${!elements[@]}"; do
            echo "${param_names[i]}: ${elements[i]}"
        done
        echo "---------------------"
    done
    echo
    read -p "These are your cars are you sure you want to delete them ? (yes/no): " answer
    echo
    if [[ $answer == "yes" ]]; then
        echo
        echo -e "Do you want to \n\n1. Delete a single car \n\n2. Delete all cars\n"
        read -p "Enter your choice(1/2) :" option
        if [ $option == 1 ]; then
            read -p "Enter you reg_no (Enter it completely):" reg_no
            echo "Your registration number is $reg_no"
            if [[ $reg_no =~ $carregex ]]; then
                echo "Deleting from DB..."
                echo
                sed -i "/$reg_no/d" carinfo.csv
                echo
                echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
                displayStuff
            else
                echo -e "reg_no not properly entered Please enter it completely for proper deletion\n"
                echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
                deletingCar
            fi
        elif [ $option == 2 ]; then
            read -p "Enter your phone_no (Enter it completely):" phone_no
            echo "Your phone number is $phone_no"
            if [[ $phone_no =~ ^[0-9]{10} ]]; then
                echo "Deleting cars from DB..."
                echo
                sed -i "/$phone_no/d" carinfo.csv
                echo
                echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
                displayStuff
            else
                echo -e "phone_no not properly entered Please enter it completely for proper deletion\n"
                echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
                deletingCar
            fi
        fi
        echo
    else
        echo "Returning to the main menu..."
        echo
        echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
        displayStuff
    fi
}
function showCars {
    echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
    echo
    if [ -z "$(tail -n +2 carinfo.csv | grep -v '^$')" ]; then
        echo "No cars present DB is empty"
        echo
        echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
        echo
        displayStuff
    else
        sed 's/,/ : /g' carinfo.csv
        echo
        echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
        echo
        displayStuff
    fi
}
function searchCar {
    echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
    echo
    read -p "Enter your phone number :" phone_no
    echo
    echo "Here is your details"
    echo
    car_info=$(grep "$phone_no" carinfo.csv)
    if [ -n "$car_info" ]; then
        echo "Car Found here is it's details"
        echo
        IFS=',' read -ra elements <<<"$car_info"
        param_names=("car_make" "car_model" "owner_name" "mobile_no" "reg_no")

        for i in "${!elements[@]}"; do
            echo "${param_names[i]}: ${elements[i]}"
        done
        echo
        displayStuff
    else
        echo "Car not found with respect to $phone_no"
        echo
        echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
        displayStuff
    fi

}
if [ ! -e "carinfo.csv" ]; then

    echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
    echo "car_make,car_model,own_name,mobileno,reg_no" >>carinfo.csv
    displayStuff

else

    echo "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"
    displayStuff

fi
