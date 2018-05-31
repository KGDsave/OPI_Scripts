#include <stdio.h>  
#include <stdlib.h>   
#include <unistd.h>
#include <time.h>
#include <string.h>

int GetCoreNumber()
{
	int many;
	int h=0;
	char path[40];
	while(1)
	{
		sprintf(path,"/sys/devices/system/cpu/cpu%d/online",h);
		if (access(path,0)!=0)
		{
			return (h-1);
		}
		h++;
	}
	return -1;
}
int CPUHZ()
{
	printf("CPU:  ");
	int rd;
	for (int q=0;q<4;q++)
	{
	char path[60];
	FILE *cp;
	sprintf(path,"/sys/devices/system/cpu/cpu%d/cpufreq/cpuinfo_cur_freq",q);
	if (access(path,0)!=0)
	{
		printf("STOP ");
		continue;
	}
	cp=fopen(path,"r");
    if(cp<0){
    puts("open file error!! need to be root!");exit (-1);}
		fscanf(cp,"%d",&rd);
		printf("%dMHZ ",rd/1000);
		fclose(cp);
    } 
    return (rd/1000);
}

int Gettemp()
{
	FILE *fd;
    int buf;
    fd=fopen("/sys/class/thermal/thermal_zone0/temp","r");
    if(fd<0){
    puts("open file error!");exit (-1);}
	fscanf(fd,"%d",&buf);
	fclose(fd);
	return buf;
}
void nowtime()
{
time_t timep;
char s[30];
time(&timep);
strcpy(s,ctime(&timep));
printf("\nTime: %s", s);
}

int main()
{
if (!(getuid()==0)){
	puts("Must run as root!");exit(0);}
while(1)
	{
		for(int jj=0;jj<100;jj++)
		{
			int temphigh=0;
			int templow=150;
			int cpuhigh=0;
			int cpulow=9999;
			long first = 1;
			for(int y=0;y<10;y++)
 		   {
   		 	if(y==0)
   			{
				nowtime();
				printf("There are %d Cores in your Computer!\n",GetCoreNumber()+1);
   		     if (first>1){
 		   		printf("CPUFreq: High:%dMHZ  Low:%dMHZ\n",cpuhigh,cpulow);
    				printf("CPUTemp: High:%d\'C Low:%d\'C\n\n",temphigh,templow);
    			}else
					puts("");
				}
    			int hzhz = CPUHZ();
    			int buf = Gettemp();
    			printf("  Temp:%d\'C \n",buf);
   			 if (buf< templow)
					templow=buf;
				if (buf>temphigh)
					temphigh=buf;
				if (cpuhigh < hzhz)
					cpuhigh = hzhz;
				if (cpulow > hzhz)
					cpulow = hzhz;
				first++;
    			usleep(1.5*1000000);
  			  }
  	  }
return 0;
}
}