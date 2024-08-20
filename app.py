import openai
from secretkey import secret_key
import json
import dbhelper
openai.api_key = secret_key

def get_answer(question):
    messages = [{'role': 'user', 'content': question}]
    functions = [
        {
            "name": "get_marks",
            "description": """Get the GPA for a college student or aggregate GPA (such as average, min, max) 
            for a given semester. If function returns -1 then it means we could not find the record in a database for given input. 
            """,
            "parameters": {
                "type": "object",
                "properties": {
                    "student_name": {
                        "type": "string",
                        "description": "First and last Name of the student. e.g John Smith",
                    },
                    "semester": {
                        "type": "integer",
                        "description": "A number between 1 to 4 indicating the semester of a student",
                    },
                    "operation": {
                        "type": "string",
                        "description": """If student is blank that means aggregate number such as max, min or average is being
                            requested for an entire semester. semester must be passed in this case. If student field is blank and say 
                            they are passing 1 as a value in semester. Then operation parameter will tell if they need a maximum, minimum
                            or an average GPA of all students in semester 1.
                            """,
                        "enum": ["max", "min", "avg"]
                    },
                },
                "required": ["semester"],
            },
        },
        {
            "name": "get_fees",
            "description": """Get the fees for an individual student or total fees for an entire 
            semester. If function returns -1 then it means we could not find the record in a database for given input.
            """,
            "parameters": {
                "type": "object",
                "properties": {
                    "student_name": {
                        "type": "string",
                        "description": "First and last Name of the student. e.g John Smith",
                    },
                    "semester": {
                        "type": "integer",
                        "description": "A number between 1 to 4 indicating the semester of a student",
                    },
                    "fees_type": {
                        "type": "string",
                        "description": "fee type such as 'paid', 'pending' or 'total'",
                        "enum": ["paid", "pending", "total"]
                    },
                },
                "required": ["semester"],
            },
        }
    ]

    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=messages,
        functions=functions,
        function_call="auto",  # auto is default, but we'll be explicit
    )
    response_message = response["choices"][0]["message"]
    # print(response_message)
    if response_message.get("function_call"):# shows function call
        available_functions = {
            "get_marks": dbhelper.get_marks,
            "get_fees": dbhelper.get_fees
        }
        function_name = response_message["function_call"]["name"]# function name
        fuction_to_call = available_functions[function_name]
        function_args = json.loads(response_message["function_call"]["arguments"])
        function_response = fuction_to_call(function_args)
        # print(function_response)
        messages.append(response_message)# establishes context
        messages.append(
            {
                "role": "function",
                "name": function_name,
                "content": str(function_response),# holds answer
            }
        )
        # Will Give human readable answer
        second_response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=messages,
        )  # get a new response from GPT where it can see the function response
        return second_response["choices"][0]["message"]["content"]
    else:
        return response_message["content"]# holds answer






if __name__ == '__main__':
    # print(get_answer("What was Hamza Jafri's GPA in semester 1?"))
    print(get_answer("average gpa in third semester?"))
    # print(get_answer("how much is Hamza Jafri's pending fees in the first semester?"))
    # print(get_answer("how much was Hamza Jafri's due fees in the first semester?"))
    # print(get_answer("what is the purpose of a balance sheet?"))