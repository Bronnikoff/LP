#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>

typedef struct person{
  char name[25];
  char surname[25];
  char id[15];
  bool sex;
  bool status;
} person;

typedef struct vector{
  person* data; //вектор состоит элементов включающих в себя данные о каждом узле родословного древа
  int size;
} vector;

int searchi(vector* vec, char id[15]); //поиск индекса в векторе для доступа
void go(FILE* f, FILE* f2, vector* vec);//функция, объедияющая 2 основных рабочих
int findid(FILE* f, FILE* f2, vector* v);//формирует вектор из данных людей и записывает мужчин
void createf(FILE* f, FILE* f2, vector* v);//записывает родителей

int searchi(vector* vec, char id[15]){
  int j;
  for(int i=0; i<vec->size; i++){
    j=0;
    while (id[j]!='\0'){
      if(id[j]!=vec->data[i].id[j]){
        break;
      }
      j++;
    }
    if(id[j]=='\0'){
      return i;
    }}}

void go(FILE* f, FILE* f2, vector* vec){
  findid(f, f2, vec);
  createf(f, f2, vec);
  return;
}

void createf(FILE* f, FILE* f2, vector* vec){
char c=fgetc(f);
int i=0, index=0;
char buffer[15];
char buf[4];
char mname[25];
char fname[25];
char msurname[25];
char fsurname[25];
while(1){
while(1){
  while (c!='G'&&c!='T'){
    c=fgetc(f);
  }
  if(c=='T'){
    for(i=0; i<3; i++){
      buf[i]=fgetc(f);
    }
    if(buf[0]=='R'&&buf[1]=='L'&&buf[2]=='R'){
      for(index=0; index < vec->size-1; index++){
        if(!vec->data[index].status){
          if(vec->data[index].sex){
            if(vec->data[index].surname[0]!='\0'){
            fprintf(f2, "father(\"%s %s\", \"\").\n", vec->data[index].surname, vec->data[index].name);
          } else{
            fprintf(f2, "father(\"nk %s\", \"\").\n", vec->data[index].name);
          }
          } else{
            if(vec->data[index].surname[0]!='\0'){
            fprintf(f2, "mother(\"%s %s\", \"\").\n", vec->data[index].surname, vec->data[index].name);
          } else{
            fprintf(f2, "mother(\"nk %s\", \"\").\n", vec->data[index].name);
          }
          }
        }
      }
      return;
    }
    c=fgetc(f);
  }
  buf[0]=fgetc(f);
  buf[1]=fgetc(f);
  c=fgetc(f);
  if(buf[0]!='M'||buf[1]!='T'){
    continue;
  }
  break;
}
c=fgetc(f);
while(c!='H'&&c!='W'){
  c=fgetc(f);
}
if(c=='H'){
  for(i=0; i<5; i++){
    fgetc(f);
  }
  c=fgetc(f);
  i=0;
  while(c!='@'){
    buffer[i++]=c;
    c=fgetc(f);
  }
  buffer[i]='\0';
  index=searchi(vec, buffer);
  vec->data[index].status = 1;
  for(i=0; vec->data[index].name[i]!='\0'; i++){
    fname[i]=vec->data[index].name[i];
  }
  fname[i]='\0';
  for(i=0; vec->data[index].surname[i]!='\0'; i++){
    fsurname[i]=vec->data[index].surname[i];
  }
  if(i==0){
    fsurname[i++]='n';
    fsurname[i++]='k';
}
  fsurname[i]='\0';
  while(c!='W'&&c!='C'){
    c=fgetc(f);
  }
  if(c=='W'){
    for(i=0; i<5; i++){
      fgetc(f);
    }
    c=fgetc(f);
    i=0;
    while(c!='@'){
      buffer[i++]=c;
      c=fgetc(f);
    }
    buffer[i]='\0';
    index=searchi(vec, buffer);
    vec->data[index].status = 1;
    for(i=0; vec->data[index].name[i]!='\0'; i++){
      mname[i]=vec->data[index].name[i];
    }
    mname[i]='\0';
    for(i=0; vec->data[index].surname[i]!='\0'; i++){
      msurname[i]=vec->data[index].surname[i];
    }
    if(i==0){
    msurname[i++]='n';
    msurname[i++]='k';
  }
    msurname[i]='\0';
    while(c!='C'){
      c=fgetc(f);
    }  }
  else{
    mname[0]='\0';
  }}
else if(c=='W'){
  for(i=0; i<5; i++){
    fgetc(f);
  }
  c=fgetc(f);
  i=0;
  while(c!='@'){
    buffer[i++]=c;
    c=fgetc(f);
  }
  buffer[i]='\0';
  index=searchi(vec, buffer);
  vec->data[index].status = 1;
  fname[0]='\0';
  for(i=0; vec->data[index].name[i]!='\0'; i++){
    mname[i]=vec->data[index].name[i];
  }
  mname[i]='\0';
  for(i=0; vec->data[index].surname[i]!='\0'; i++){
    msurname[i]=vec->data[index].surname[i];
  }
  if(i==0){
    msurname[i++]='n';
    msurname[i++]='k';
  }
  msurname[i]='\0';
  while (c!='C'){
    c=fgetc(f);
  }}
while(1){
while (c!='C'&&c!='R'){
  c=fgetc(f);
}
if(c=='R'){
  break;
}
for(i=0; i<5; i++){
  fgetc(f);
}
c=fgetc(f);
i=0;
while(c!='@'){
  buffer[i++]=c;
  c=fgetc(f);
}
buffer[i]='\0';
index=searchi(vec, buffer);
if(fname[0]!='\0'){
fprintf(f2, "father(\"%s %s\", \"%s %s\").\n", fsurname, fname, vec->data[index].surname, vec->data[index].name);
}
if(mname[0]!='\0'){
  fprintf(f2, "mother(\"%s %s\", \"%s %s\").\n", msurname, mname, vec->data[index].surname, vec->data[index].name);
}}
}
}

int findid(FILE* f, FILE* f2, vector* vec){
  char c=fgetc(f);
  int i=0, j=0;
  char buf[4];
  char buffer[25];
  while(1){
    j=0;
    c=fgetc(f);
  while (c!='@'){
    c=fgetc(f);
  }
  c=fgetc(f);
  while(c!='@'){
    buffer[j++]=c;
    c=fgetc(f);
  }
  i=j;
  fgetc(f);
  for(j=0; j<4; j++){
    buf[j]=fgetc(f);
  }
  if(buf[0]=='I'&&buf[1]=='N'&&buf[2]=='D'&&buf[3]=='I'){
    for(j=0; j<i; j++){
      vec->data[(vec->size)-1].id[j]=buffer[j];
    }
    vec->data[(vec->size)-1].id[j]='\0';

    while(1){
      while(c!='N'){
        c=fgetc(f);
      }
      for(j=0; j<3; j++){
        buf[j]=fgetc(f);
      }
      if(buf[0]=='A'&&buf[1]=='M'&&buf[2]=='E'){
        j=0;
        break;
      }}
      fgetc(f);
      c=fgetc(f);
      while(c!=' '){
        vec->data[(vec->size)-1].name[j++]=c;
        c=fgetc(f);
      }
        vec->data[(vec->size)-1].name[j]='\0';
      j=0;
      fgetc(f);
      c=fgetc(f);
      while(c!='/'){
        vec->data[(vec->size)-1].surname[j++]=c;
        c=fgetc(f);
      }
        vec->data[(vec->size)-1].surname[j]='\0';
      while (1){
      while(c!='S'){
        c=fgetc(f);
      }
      for(i=0; i<4; i++){
        buf[i]=fgetc(f);
      }
      c=fgetc(f);
      if(buf[0]=='E'&&buf[1]=='X'){
        if(buf[3]=='M'){
        vec->data[vec->size-1].sex = 1;
      } else{
        vec->data[vec->size-1].sex = 0;
      }
        break;
      }
    }
      vec->size+=1;
      vec->data=(person*)realloc(vec->data, (vec->size)*sizeof(person));
      vec->data[vec->size-1].status = 0;
      }
  else if(buf[0]=='F'&&buf[1]=='A'&&buf[2]=='M'){
    return 0;
  }}}

int main(){
  vector vec;
  vec.size=1;
  vec.data=(person*)malloc(sizeof(person));
  char buffer[15];
  printf("Здравствуйте!\nРаботу выполнил Бронников Максим (№1 по списку, М80-204Б)\nВведите имя исходного файла: ");
  scanf("%s", buffer);
  FILE* file1=fopen(buffer, "rt");//открываем файл gedcom
  printf("Введите имя выходного файла: ");
  scanf("%s", buffer);
  FILE* f2=fopen(buffer, "wt");//open second file for write
  go(file1,f2, &vec);
  free(vec.data);
  fclose(f2);
  fclose(file1);
  printf("Преобразование выполнено в файл:%s\nДо свидания!\n", buffer);
  return 0;
}
