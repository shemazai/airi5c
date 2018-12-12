#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
	unsigned int templong;
	FILE *fp;
	FILE *fpo;
	char *stringbuf;	
	char *ptr;	
	char *buffer[4];
	int i;
	printf("convert %s -> %s\r\n",argv[1],argv[2]);
	fp = fopen(argv[1],"r");
	fpo = fopen(argv[2],"w");
	stringbuf = malloc(sizeof(char) * 2000);
	i = 0;	
	while(fgets(stringbuf,2000,fp) != NULL)
	{
		if(strchr(stringbuf,'@') != NULL)
		{
			char* convbuf; convbuf = malloc(sizeof(char)*2000);
			char* convptr;
			sprintf(convbuf,"%s",strtok(stringbuf,"\r\n"));
//			fprintf(fpo,"%s\r\n",convbuf);				
			printf("[%s] -> ",convbuf);
			ptr = &convbuf[1];
			templong = (int)strtol(ptr,NULL,16);
			printf("[%lu] -> ",templong);
			templong = (templong - 0x80000000) / 4;
			printf("[%lu] -> ",templong);
			sprintf(convbuf,"%lx",templong);
			printf("[%s]\r\n",convbuf);
			fprintf(fpo,"@%s\r\n",convbuf);				
			free(convbuf);
//			fprintf(fpo,"%s\r\n",strtok(stringbuf,"\r\n"));
			i = 0;
		}
		else
		{
			ptr = strtok(stringbuf," \r\n");
//			fprintf(fpo,"%s\r\n",stringbuf);	
			while(ptr != NULL)
			{
				buffer[i] = malloc(strlen(ptr)*sizeof(char));
				sprintf(buffer[i],"%s",ptr);
				i++; if(i > 3)
				{ 			
					fprintf(fpo,"%s%s%s%s\r\n",buffer[3],buffer[2],buffer[1],buffer[0]);					
					free(buffer[3]);free(buffer[2]);free(buffer[1]);free(buffer[0]);
					i = 0;
				}			
				ptr = strtok(NULL," \r\n");
			}
		}
	}
	free(stringbuf);
	fclose(fp);fclose(fpo);
	printf("done.\r\n");
	return(0);
}
