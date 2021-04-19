function [in_total_secret, in_message, in_secret_array, in_reEncode_A, in_reEncode_B, in_return_indicator, in_code] = get_message (T_number, total_secret, message, secret_array,reEncode_A, reEncode_B,return_indicator,total_secret_T, message_T, secret_array_T,reEncode_A_T, reEncode_B_T,return_indicator_T,code,  code_T) 
if (T_number == 3)
                    in_total_secret = total_secret
                    in_message = message;
                    in_secret_array = secret_array;
                    in_reEncode_A = reEncode_A;
                    in_reEncode_B = reEncode_B;
                    in_return_indicator = return_indicator;
                    in_code = code; 
                else 
                    in_total_secret = total_secret_T
                    in_message = message_T;
                    in_secret_array = secret_array_T;
                    in_reEncode_A = reEncode_A_T;
                    in_reEncode_B = reEncode_B_T;
                    in_return_indicator = return_indicator_T;       
                    in_code = code_T;
                end 