/***************************************************************************/
/* strategy_c(req_hdr)                                                     */
/*  Strategy function. Called by assembler portion of strategy entry point */
/*  of DD, this is functionally the strategy entry point.  It looks at the */
/*  command portion of the request packet an calls the proper function.    */
/*                                                                         */
/*  There is only 1 command that really does anything - INIT.  Others      */
/*  don't but say we did.  Finally, the rest Return BAD_CMD.               */
/*                                                                         */
/*  All commands return a value that will be ORed with the DONE bit and    */
/*  set into the request packet's STATUS field via DEV_DONE.               */
/*                                                                         */
/***************************************************************************/
#include "demo.h"

int near strategy_c(req_hdr)
struct reqhdr *req_hdr;
{
  word rc;
  boolean entered_real;

  /* Insure that we are in protect mode */
  entered_real = to_prot_mode();

  /* Check to see if the command is outside the range of valid commands */
  if (req_hdr->rh_cmd > MAXCMD) { rc = bad_cmd(); }
  else {

  /* Different commands call for different functions */
     switch (req_hdr->rh_cmd) {
        case  0 :
                  rc = init_mod((struct init_hdr_in *)req_hdr);    /* Init */
                  break;
        case  1 :
                  rc = bad_cmd();            /* Media Check */
                  break;
        case  2 :
                  rc = bad_cmd();            /* Build BPB */
                  break;
        case  3 :
                  rc = bad_cmd();            /* Reserved */
                  break;
        case  4 :
                  rc = bad_cmd();            /* Read */
                  break;
        case  5 :
                  rc = bad_cmd();            /* Non-destructive Read */
                  break;
        case  6 :
                  rc = bad_cmd();            /* Input Status */
                  break;
        case  7 :
                  rc = bad_cmd();            /* Input Flush */
                  break;
        case  8 :
                  rc = 0;                    /* Write */
                  break;
        case  9 :
                  rc = bad_cmd();            /* Write with Verify */
                  break;
        case 10 :
                  rc = bad_cmd();            /* Output Status */
                  break;
        case 11 :
                  rc = 0;                    /* Output Flush */
                  break;
        case 12 :
                  rc = bad_cmd();            /* Reserved */
                  break;
        case 13 :
                  rc = 0;                    /* Open */
                  break;
        case 14 :
                  rc = 0;                    /* Close */
                  break;
        case 15 :
                  rc = bad_cmd();            /* Removable Media */
                  break;
        case 16 :
                  rc = 0;                    /* IOCtl      */
                  break;
        case 17 :
                  rc = bad_cmd();            /* Reset media */
                  break;
        case 18 :
                  rc = bad_cmd();            /* Get Logical Drive Map */
                  break;
        case 19 :
                  rc = bad_cmd();            /* Set Logical Drive Map */
                  break;
        case 20 :
                  rc = 0;                    /* De-install */
                  break;
        case 21 :
                  rc = bad_cmd();            /* Port Access */
                  break;
        case 22 :
                  rc = bad_cmd();            /* Partitionable Fixed Disks */
                  break;
        case 23 :
                  rc = bad_cmd();            /* Get Logical Unit Map */
                  break;
        case 24 :
                  rc = bad_cmd();            /* Reserved */
                  break;
        case 25 :
                  rc = bad_cmd();            /* Reserved */
                  break;
        case 26 :
                  rc = bad_cmd();            /* Reserved */
                  break;

        case 27 :
                  rc = bad_cmd();            /* Reserved */
                  break;

        default :                            /* Just in case */
                  rc = bad_cmd();
                  break;
     } /* switch */
   } /* else */

  /* Unblock the waiting app */
  if (req_hdr->rh_cmd) { dev_done(req_hdr,rc); }
  else { req_hdr->rh_stat = DONE; }

  /* Go back to real mode if we entered in real mode */
  if (entered_real) {to_real_moda(); }

  return(SUCCESS);

}
