/* Linear Table On Sequence Structure */
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>

/*---------page 10 on textbook ---------*/
#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR -1
#define INFEASTABLE -2
#define OVERFLOW -3
#define LIST_MAXN 10

typedef int status;
typedef int ElemType; //数据元素类型定义

/*-------page 22 on textbook -------*/
#define LIST_INIT_SIZE 100
#define LISTINCREMENT  10
typedef struct{  //顺序表（顺序结构）的定义
	ElemType * elem = NULL;     // c++ 11
	int length = 0;
	int listsize = 0;
}SqList;
/*-----page 19 on textbook ---------*/
status IntiaList(SqList & L);
status DestroyList(SqList & L);
status ClearList(SqList &L);
status ListEmpty(SqList L);
int ListLength(SqList L);
status GetElem(SqList L,int i,ElemType & e);
//status LocateElem(SqList L,ElemType e); // 简化过
int LocateElem(SqList L,ElemType e); // 原版拿status返回位序感觉不合理
status PriorElem(SqList L,ElemType cur,ElemType & pre_e);
status NextElem(SqList L,ElemType cur,ElemType & next_e);
status ListInsert(SqList & L,int i,ElemType e);
status ListDelete(SqList & L,int i,ElemType & e);
status ListTrabverse(SqList L);  //简化过
void DisplayAllList();
void ChangeList(int i);

/*--------------------------------------------*/
SqList L[LIST_MAXN];  // 没有泛型多表还是直接数组了
int plist = 0;

int main(void){

  int temp;

  int op=1;
  FILE *pFile;
  status t;
  int i, e, pre_e, next_e;
  int len;
  char filename[FILENAME_MAX];
  while(op){
	system("cls");	printf("\n\n");
	printf("      Menu for Linear Table On Sequence Structure \n");
	printf("-------------------------------------------------\n");
	printf("Function Menu:\n");
	printf("    	  1. IntiaList       7. LocateElem\n");
	printf("    	  2. DestroyList     8. PriorElem\n");
	printf("    	  3. ClearList       9. NextElem \n");
	printf("    	  4. ListEmpty     10. ListInsert\n");
	printf("    	  5. ListLength     11. ListDelete\n");
	printf("    	  6. GetElem       12. ListTrabverse\n");
	printf("\n\nSystem Settings:\n");
	printf("          13. All list     14. Change list\n");
	printf("          15. Save List    16. Load List\n");
	printf("    	  0. Exit\n");
	printf("-------------------------------------------------\n");
	printf("    请选择你的操作[0~16]:");
	scanf("%d",&op);
    switch(op){
	   case 1:
		 //printf("\n----IntiaList功能待实现！\n");
		 if(IntiaList(L[plist])==OK) printf("线性表创建成功！\n");
		     else printf("线性表创建失败！\n");
		 getchar();getchar();
		 break;
	   case 2:
		 printf("\n----DestroyList----\n");
         DestroyList(L[plist]);
		 getchar();getchar();
		 break;
	   case 3:
		 printf("\n----ClearList----\n");
		 ClearList(L[plist]);
		 getchar();getchar();
		 break;
	   case 4:
		 printf("\n----ListEmpty----\n");
		 if(ListEmpty(L[plist]))printf("List is Empty\n");
		 else printf("List is not Empty\n");
		 getchar();getchar();
		 break;
	   case 5:
		 printf("\n----ListLength----\n");
		 len = ListLength(L[plist]);
         if(len != INFEASTABLE)printf("The length of list is %d\n", len);
         else printf("List is not initial!\n");
		 getchar();getchar();
		 break;
	   case 6:
		 printf("\n----GetElem----\n");
		 printf("Please enter the index in the list you want to get(starting as 1)\n");
         scanf("%d", &i);
         if(GetElem(L[plist], i - 1, e) == OK)printf("Value = %d\n", e);
         else printf("Error : The list is not inital or index out of range.\n");
		 getchar();getchar();
		 break;
	   case 7:
		 printf("\n----LocateElem----\n");
         printf("Please enter the value of elem you want to locate.\n");
         scanf("%d", &e);
         i = LocateElem(L[plist], e);
         if(i > 0)
            printf("The serial number of value %d is %d\n", e, i + 1);
         else
            printf("Error : The list is not inital or elem is not in the list.\n");
		 getchar();getchar();
		 break;
	   case 8:
		 printf("\n----PriorElem----\n");
         printf("Please enter the value you want to get prior elem.\n");
         scanf("%d", &e);
         t = PriorElem(L[plist], e, pre_e);
         if(t == OK)printf("prior elem is %d\n", pre_e);
         else if(t == FALSE)printf("elem is not found or have no prior elem!\n");
         else printf("Error : The list is not inital.\n");
		 getchar();getchar();
		 break;
	   case 9:
		 printf("\n----NextElem----\n");
         printf("Please enter the value you want to get next elem.\n");
         scanf("%d", &e);
         t = NextElem(L[plist], e, next_e);
         if(t == OK)printf("next elem is %d\n", next_e);
         else if(t == FALSE)printf("elem is not found or have no next elem!\n");
         else printf("Error : The list is not inital.\n");
		 getchar();getchar();
		 break;
	   case 10:
		 printf("\n----ListInsert----\n");
         printf("Please enter the index and value you want to insert.\n");
         scanf("%d %d", &i, &e);
         t = ListInsert(L[plist], i - 1, e);
         if(t == OK)printf("insert success!\n");
         else if(t == FALSE)printf("index out of range.\n");
         else printf("list full or not initial!\n");
		 getchar();getchar();
		 break;
	   case 11:
		 printf("\n----ListDelete----\n");
		 printf("Please enter the index you want to delete.\n");
		 scanf("%d", &i);
		 t = ListDelete(L[plist], i - 1, e);
		 if(t == OK)printf("you deleted %d\n", e);
		 else if(t == FALSE)printf("index out of range.\n");
		 else printf("list is not initial!\n");
		 getchar();getchar();
		 break;
	   case 12:
		 printf("\n-----------all elements -----------------------\n");
		 ListTrabverse(L[plist]);
		 printf("\n------------------ end ------------------------\n");
		 if(ListEmpty(L[plist])) printf("线性表是空表！\n");
		 getchar();getchar();
		 break;
       case 13:
         DisplayAllList();
         break;
       case 14:
         printf("Please enter the list number you want to operate:\n");
         scanf("%d", &i);
         ChangeList(i);
         break;
       case 15:
         printf("Please enter the list file name you want to save:\n");
         scanf("%s", filename);

         len = ListLength(L[plist]);

         // 站在认为存储是类似序列化的特殊操作的角度
         // 直接访问抽象数据类型内部elem应该是合理的
         pFile = fopen(filename, "w");
         fprintf(pFile, "%d\n", len);
         for(i = 0; i < len; i++)
            fprintf(pFile, "%d ", L[plist].elem[i]);
         fclose(pFile);

         getchar();
         break;
       case 16:
         DestroyList(L[plist]);
         printf("Please enter the list file name:\n");
         scanf("%s", filename);
         if(freopen(filename, "r", stdin) == NULL)
         {
             printf("can not open the file!\n");
             freopen("CON", "r", stdin);
             getchar();
             break;
         }
         IntiaList(L[plist]);
         scanf("%d", &len);
         for(i = 0; i < len; i++)
         {
             scanf("%d", &e);
             ListInsert(L[plist], i, e);
         }
         freopen("CON", "r", stdin);
         break;
	   case 0:
         break;
       default:
         break;
	}//end of switch
  }//end of while
  printf("欢迎下次再使用本系统！\n");
  return 0;
}//end of main()

void ChangeList(int i)
{
    if(i > 0 && i <= LIST_MAXN)
        plist = i - 1;
    else
        printf("list number illegal.\n");
}

void DisplayAllList()
{
    int temp = 0;
    int i;
    printf("All list:\n");
    for(i = 0; i < LIST_MAXN; i++)
    {
        if(L[i].listsize > 0)
        {
            printf("L%d length %d\n", i + 1, ListLength(L[i]));
            temp++;
        }
    }
    if(temp == 0)printf("no list initial!\n");
    getchar();getchar();
    return;
}

/*--------page 23 on textbook --------------------*/
status IntiaList(SqList & L)
{
	L.elem = (ElemType *)malloc( LIST_INIT_SIZE * sizeof (ElemType));
    if(!L.elem) exit(OVERFLOW);
	L.length=0;
    L.listsize=LIST_INIT_SIZE;
	return OK;
}
status DestroyList(SqList & L)
{
    if(L.listsize <= 0)return OK;
    free(L.elem);
    L.elem = NULL;
	L.length = 0;
	L.listsize = 0;
    return OK;
}
status ClearList(SqList &L)
{
    int i;
    L.length = 0;
    return OK;
}
status ListEmpty(SqList L)
{
    return L.length == 0;
}
int ListLength(SqList L)
{
    if(L.listsize == 0)return INFEASTABLE;
    return L.length;
}
status GetElem(SqList L,int i,ElemType & e)
{
    if(i >= L.length)return ERROR;
    e = L.elem[i];
    return OK;
}
int LocateElem(SqList L,ElemType e)
{
    int i;
    if(L.listsize <= 0)return -2;
    for(i = 0; i < L.length; i++)
    {
        if(L.elem[i] == e)
        {
            return i;
        }
    }
    return -1;
}
status PriorElem(SqList L,ElemType cur,ElemType & pre_e)
{
    if(L.listsize <= 0)return ERROR;
    int x = LocateElem(L, cur);
    if(x >= 1)pre_e = L.elem[x - 1];
    else return FALSE;
    return OK;
}
status NextElem(SqList L,ElemType cur,ElemType & next_e)
{
    if(L.listsize <= 0)return ERROR;
    int x = LocateElem(L, cur);
    if(x < 0 || x >= L.length - 1)return FALSE;
    next_e = L.elem[x + 1];
    return OK;
}
status ListInsert(SqList & L,int i,ElemType e)
{
    int j;
    if(L.length == L.listsize - 1 || L.listsize <= 0)return ERROR;     // Full
    if(i >= 0 && i <= L.length)
    {
        for(j = L.length; j >= i + 1; j--)
            L.elem[j] = L.elem[j - 1];
        L.length++;
        L.elem[i] = e;
        return OK;
    }
    return FALSE;
}
status ListDelete(SqList & L,int i,ElemType & e)
{
    int j;
    if(L.listsize <= 0)return ERROR;
    if(i >= 0 && i < L.length)
    {
        e = L.elem[i];
        for(j = i; j < L.length - 1; j++)
            L.elem[j] = L.elem[j + 1];
        L.length--;
        return OK;
    }
    return FALSE;
}

status ListTrabverse(SqList L)
{
   int i;

   for(i = 0 ; i < L.length; i++) printf("%d ",L.elem[i]);

   //return L.length;     // 为什么模板要拿status返回length
   return OK;
}
