
#!/bin/bash

SCORE_FILE="math_quiz_scores.txt"

get_level() {
    if [ $score -lt 5 ]; then
        echo "Level: Beginner"
    elif [ $score -lt 10 ]; then
        echo "Level: Intermediate"
    elif [ $score -lt 20 ]; then
        echo "Level: Advanced"
    else
        echo "Level: Math Wizard"
    fi
}


show_reward() {
    if [ $score -eq 5 ]; then
        echo "You're improving....."
    elif [ $score -eq 10 ]; then
        echo "You're doing really well....:)"
    elif [ $score -eq 20 ]; then
        echo "You're a math genius.....>>"
    fi
}


ask_question() {
    if [ $score -lt 5 ]; then
        max_num=10
    elif [ $score -lt 10 ]; then
        max_num=20
    else
        max_num=50
    fi

    operation=$((RANDOM % 7))
    num1=$((RANDOM % max_num + 1))
    num2=$((RANDOM % max_num + 1))

    case $operation in
        0) correct_answer=$((num1 + num2))
           question="What is $num1 + $num2?" ;;
        1) correct_answer=$((num1 - num2))
           question="What is $num1 - $num2?" ;;
        2) correct_answer=$((num1 * num2))
           question="What is $num1 * $num2?" ;;
        3)
            while [ $num2 -eq 0 ]; do
                num2=$((RANDOM % max_num + 1))
            done
            correct_answer=$((num1 / num2))
            question="What is $num1 / $num2? (Integer division)" ;;
        4)
            while [ $num2 -eq 0 ]; do
                num2=$((RANDOM % max_num + 1))
            done
            correct_answer=$((num1 % num2))
            question="What is $num1 % $num2? (Remainder)" ;;
        5) correct_answer=$((num1 * num1))
           question="What is $num1 squared?" ;;
        6)
            question="Is $num1 even or odd? (Type 'even' or 'odd')"
            echo "$question"
            read -t 10 -p "Your answer: " user_answer
            if (( num1 % 2 == 0 )); then
                correct="even"
            else
                correct="odd"
            fi

            if [[ "$user_answer" == "$correct" ]]; then
                echo "Correct!"
                return 1
            else
                echo "Incorrect! The correct answer was $correct."
                return 0
            fi
            return ;;
    esac

    echo "$question"
    read -t 10 -p "Your answer: " user_answer

    if [[ $? -ne 0 ]]; then
        echo -e "\nTime's up"
        echo "The correct answer was $correct_answer."
        return 0
    fi

    if [[ "$user_answer" -eq "$correct_answer" ]]; then
        echo "Correct!"
        return 1
    else
        echo "Incorrect...... The correct answer was $correct_answer."
        return 0
    fi
}


play_game() {
    score=0
    correct_count=0
    incorrect_count=0

    read -p "Enter your name: " player_name

    while true; do
        ask_question
        result=$?

        if [[ $result -eq 1 ]]; then
            score=$((score + 1))
            correct_count=$((correct_count + 1))
            show_reward
        else
            incorrect_count=$((incorrect_count + 1))
        fi

        echo "Score: $score | Correct: $correct_count | Incorrect: $incorrect_count"
        get_level
        echo "--------------------------------"

        read -p "Do you want to continue? (y/n): " continue_game
        if [[ "$continue_game" != "y" ]]; then
            echo "Thanks for playing, $player_name!"
            echo "Final Score: $score | Correct: $correct_count | Incorrect: $incorrect_count"
            get_level


            echo "$player_name - Score: $score | Correct: $correct_count | Incorrect: $incorrect_count" >> "$SCORE_FILE"
            echo "Your score has been saved in $SCORE_FILE"
            break
        fi
    done
}


echo "Welcome to the Advanced Math Quiz Game :)"
echo "You have 10 seconds to answer each question."
echo "Let's begin...."
play_game
