/*
 * linuxrun.c - Minimal Linux kernel module example
 *
 * Instructions:
 * 1) Install kernel headers and build tools (on host):
 *      sudo apt update
 *      sudo apt install build-essential linux-headers-$(uname -r)
 *
 * 2) Create a simple Makefile in the same directory (Makefile):
 *
 *      
 *
 *      all:
 *      	$(MAKE) -C $(KDIR) M=$(PWD) modules
 *
 *      clean:
 *      	$(MAKE) -C $(KDIR) M=$(PWD) clean
 *
 *   (Note: the lines before $(MAKE) must start with a tab.)
 *
 * 3) Build the module:
 *      make
 *
 * 4) Insert the module (example with parameters):
 *      sudo insmod linuxrun.ko message="Hello from module" debug=1
 *
 * 5) Check kernel log:
 *      dmesg | tail -n 40
 *    or live follow:
 *      sudo dmesg -w
 *
 * 6) Show module info:
 *      modinfo linuxrun.ko
 *
 * 7) Remove the module:
 *      sudo rmmod linuxrun
 *
 * 8) Clean:
 *      make clean
 *
 * This file is intentionally minimal and safe. Don't run modules from untrusted sources.
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/moduleparam.h>
#include <linux/utsname.h>
#include <linux/cpumask.h>
#include <linux/delay.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("GitHub Copilot");
MODULE_DESCRIPTION("Minimal Linux kernel module example (linuxrun)");
MODULE_VERSION("0.1");

/* Module parameters */
static char *message = "default";
static int debug = 0;

module_param(message, charp, 0444);
MODULE_PARM_DESC(message, "A message to print when the module loads");

module_param(debug, int, 0444);
MODULE_PARM_DESC(debug, "Enable debug prints (0=off, 1=on)");

/* init function */
static int __init linuxrun_init(void)
{
    pr_info("=================================================\n");
    pr_info("linuxrun: module loaded successfully!\n");
    pr_info("message: \"%s\"\n", message);
    pr_info("debug: %d\n", debug);
    pr_info("=================================================\n");

    msleep(1000);

    if (debug) {
        pr_info("DEBUG MODE ENABLED - Additional diagnostics:\n");
        pr_info("  - Kernel version: %s\n", utsname()->release);
        pr_info("  - CPU count: %d\n", num_online_cpus());
    }

    /* Return 0 for successful load */
    return 0;
}

/* exit function */
static void __exit linuxrun_exit(void)
{
    pr_info("linuxrun: module unloaded\n");
}

module_init(linuxrun_init);
module_exit(linuxrun_exit);
