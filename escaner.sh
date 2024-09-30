


nmap  -Pn -iL ip.txt --open -n --randomize-hosts --max-retries 1   -p 25,587,465,110,143,995,993 --script "pop3-capabilities or pop3-ntlm-info" -oG resultado2.txt 


