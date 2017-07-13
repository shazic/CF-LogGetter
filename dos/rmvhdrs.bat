@rem $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
@rem $$                                                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                         PURPOSE                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                                                             $$
@rem $$  REMOVES HEADER RECORDS FROM THE CONSOLIDATED LOG FILE.     $$
@rem $$  THIS BAT FILE REMOVES THE RECORDS THAT STARTS WITH A #     $$
@rem $$  SYMBOL AT THE FIRST POSITION.                              $$
@rem $$                                                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                          SYNTAX                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                                                             $$
@rem $$  RMVHDRS     INPUT_CONSOLIDATED_LOG_FILE     OUTPUT         $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                          OUTPUT                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                                                             $$
@rem $$  FILE:                                                      $$
@rem $$              THE CONTENT IS SAME AS THE INPUT FILE, WITHOUT $$
@rem $$              THE HEADER RECORDS.                            $$
@rem $$                                                             $$
@rem $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

@echo off
SETLOCAL DisableDelayedExpansion
FOR /F "usebackq delims=" %%a in (`"findstr /n ^^ %1"`) do (
    set "var=%%a"
    SETLOCAL EnableDelayedExpansion
    set "var=!var:*:=!"
    set "frstsmbl=!var:~0,1!"
    if "!frstsmbl!" NEQ "#" echo(!var! >> %2
    ENDLOCAL
)
