# Home-Assistant-ZTE-MF286D-reboot
Shell script for reboot ZTEMF286D modem

Copy the file mf286d_reboot.sh in your config directory or in a subbfolder, example config/shell

Edit mf286d_reboot.sh file changing all IP address 192.16.32.1 recurrence with your modem IP address.

Edit line 18 entering your modem password encoded first to Base64 and after SHA256, you can use this online encode service https://emn178.github.io/online-tools/
in the example the password is "Testpassword" ->Base64encode -> VGVzdHBhc3N3b3Jk -> SHA256 -> D55468C746779416A70BCFD78A348012EDFE669CD7987DAE35DF13AC16CC40F2

 --data 'isTest=false&goformId=LOGIN&password=D55468C746779416A70BCFD78A348012EDFE669CD7987DAE35DF13AC16CC40F2' \



### Enter following configuration on your config.yaml, save and restart Home Assistant
#### Example config.yaml configuration

```yaml
shell_command:
   restart_modem_zte_2: /bin/bash /config/shell/mf286d_reboot.sh
```

Now on Developer tools -> Actions enter shell_command.restart_modem_zte and click Perform action to restart the modem or you can use action in Automations
