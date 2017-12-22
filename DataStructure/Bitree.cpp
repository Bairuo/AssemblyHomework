/* Binary Tree On Chain Structure */
#include <stdio.h>
#include <iostream>
#include "Bitree.hpp"
#define TREE_MAXN 10

bool InitBiTree(BiTree *T);
bool DestroyBiTree(BiTree *T);
bool ClearBiTree(BiTree *T);
bool Print(ElemType e);
bool Save(BiTNode *T);

/*--------------------------------------------*/
BiTree *trees[TREE_MAXN];
BiTree *pt;
FILE *pFile;

int ptree = 0;

int main(void){

  int temp;

  int op=1;

  status t;
  ElemValue display;
  int i, e;

  int n;
  int id, lr, data;

  int depth1, depth2;

  char filename[FILENAME_MAX];

  while(op){
	system("cls");
	printf("      Menu for Binary Tree On Chain Structure \n");
	printf("-------------------------------------------------\n");
	printf("    	  1. InitBiTree         2. DestroyBiTree\n");
	printf("    	  3. CreateBiTree       4. ClearBiTree\n");
	printf("    	  5. BiTreeEmpty        6. BiTreeDepth\n");
	printf("    	  7. Root               8. Value\n");
	printf("    	  9. Assign             10. Parent\n");
	printf("    	  11. LeftChild         12. RightChild\n");
	printf("    	  13. LeftSibling       14. RightSibling\n");
	printf("    	  15. InsertChild       16. DeleteChild\n");
    printf("    	  17. PreOrderTraverse  18. InOrderTraverse\n");
	printf("    	  19. PostOrderTraverse 20. LevelOrderTraverse\n");
    printf("\n");
	printf("          21. All Tree     22. Change Tree\n");
	printf("          23. Save Tree    24. Load Tree\n");
	printf("    	  0. Exit\n");
	printf("-------------------------------------------------\n");
	printf("      Please choose your operation[0~24]:");
	scanf("%d", &op);
    switch(op){
	   case 1:
         printf("\n----InitBiTree----\n");
		 if(InitBiTree(trees[ptree])) printf("二叉树初始化成功！\n");
		     else printf("二叉树初始化失败，已存在二叉树或内存分配失败！\n");
		 getchar();getchar();
		 break;
	   case 2:
         printf("\n----DestroyBiTree----\n");
		 if(DestroyBiTree(trees[ptree])) printf("已摧毁当前二叉树\n");
		     else printf("二叉树不存在！\n");
		 getchar();getchar();
		 break;
	   case 3:
         printf("\n----CreateBiTree----\n");
         printf("Please enter tree node(key and value) in preOrder : ");
         getchar();
         CreateBiTree(trees[ptree], trees[ptree]);
         printf("You have created the tree.\n");
         getchar();getchar();
		 break;
	   case 4:
         printf("\n----ClearBiTree----\n");
		 if(ClearBiTree(trees[ptree])) printf("已清空当前二叉树\n");
		     else printf("二叉树不存在！\n");
		 getchar();getchar();
		 break;
	   case 5:
         printf("\n----BiTreeEmpty----\n");
         if(!trees[ptree])printf("二叉树尚未初始化！\n");
         if(BiTreeEmpty(trees[ptree]))
            printf("二叉树为空\n");
         else
            printf("二叉树非空\n");
         getchar();getchar();
		 break;
	   case 6:
         printf("\n----BiTreeDepth----\n");
         if(!trees[ptree])printf("二叉树尚未初始化！\n");
         printf("二叉树深度：%d\n", BiTreeDepth(trees[ptree]));
         getchar();getchar();
		 break;
	   case 7:
         printf("\n----Root----\n");
         if(trees[ptree] == NULL)
         {
             printf("当前树未初始化！\n");
         }
         else
         {
            pt = trees[ptree];
            printf("已获得当前树根节点！\n");
         }
         getchar();getchar();
		 break;
	   case 8:
         printf("\n----Value----\n");
         printf("Please enter the key number of the node: ");
         scanf("%d", &id);
         display = Value(trees[ptree], id);
         if(display != 0)
            printf("The value is %c\n", display);
         getchar();getchar();
		 break;
	   case 9:
         printf("\n----Assign----\n");
         printf("Please enter the key number and the value you want to assign: ");
         scanf("%d %c", &id, &data);
         Assign(trees[ptree], id, data);
         getchar();
		 break;
	   case 10:
         printf("\n----Parent----\n");
         printf("Please enter the key number of the node: ");
         scanf("%d", &id);
         pt = Parent(trees[ptree], id);
         getchar();getchar();
		 break;
	   case 11:
         printf("\n----LeftChild----\n");
         printf("Please enter the key number of the node: ");
         scanf("%d", &id);
         pt = LeftChild(trees[ptree], id);
         getchar();getchar();
		 break;
	   case 12:
         printf("\n----RightChild----\n");
         printf("Please enter the key number of the node: ");
         scanf("%d", &id);
         pt = RightChild(trees[ptree], id);
         getchar();getchar();
		 break;
       case 13:
         printf("\n----LeftSibling----\n");
         printf("Please enter the key number of the node: ");
         scanf("%d", &id);
         pt = LeftSibling(trees[ptree], id);
         getchar();getchar();
         break;
       case 14:
         printf("\n----RightSibling----\n");
         printf("Please enter the key number of the node: ");
         scanf("%d", &id);
         pt = RightSibling(trees[ptree], id);
         getchar();getchar();
         break;
       case 15:
         printf("\n----InsertChild----\n");
         printf("Please enter the key number of the node you want to insert: ");
         scanf("%d", &id);
         printf("Please enter left(0) or right(1): ");
         scanf("%d", &lr);
         pt = Get(trees[ptree], id);
         if(pt == NULL)
         {
             break;
         }

         printf("Please enter sub tree node in preOrder : ");
         getchar();
         if(lr == 0)
         {
             if(pt->lchild != NULL)
             {
                 printf("左子树不为空！\n");
                 break;
             }
             CreateBiTree(pt->lchild, pt);
         }
         else
         {
             if(pt->rchild != NULL)
             {
                 printf("右子树不为空！\n");
                 break;
             }
             CreateBiTree(pt->rchild, pt);
         }

         depth1 = pt->lchild == NULL ? 0 : pt->lchild->depth;
         depth2 = pt->rchild == NULL ? 0 : pt->rchild->depth;
         pt->depth = std::max(depth1, depth2) + 1;
         std::cout << depth1 << " " << depth2 << std::endl;

         while(pt->parent != pt)
         {
             pt = pt->parent;
             depth1 = pt->lchild == NULL ? 0 : pt->lchild->depth;
             depth2 = pt->rchild == NULL ? 0 : pt->rchild->depth;
             pt->depth = std::max(depth1, depth2) + 1;
         }

         printf("Successful insert.\n");
         getchar();getchar();
         break;
       case 16:
         printf("\n----DeleteChild----\n");
         printf("Please enter the key number of the node you want to delete: ");
         scanf("%d", &id);
         printf("Please enter left(0) or right(1): ");
         scanf("%d", &lr);
         pt = Get(trees[ptree], id);
         if(pt == NULL)
         {
             break;
         }

         if(lr == 0)
            FreeBiTree(pt->lchild);
         else
            FreeBiTree(pt->rchild);

         depth1 = pt->lchild == NULL ? 0 : pt->lchild->depth;
         depth2 = pt->rchild == NULL ? 0 : pt->rchild->depth;
         pt->depth = std::max(depth1, depth2) + 1;

         while(pt->parent != pt)
         {
             pt = pt->parent;
             depth1 = pt->lchild == NULL ? 0 : pt->lchild->depth;
             depth2 = pt->rchild == NULL ? 0 : pt->rchild->depth;
             pt->depth = std::max(depth1, depth2) + 1;
         }

         printf("Successful delete.\n");
         getchar();getchar();
         break;
       case 17:
         printf("\n----PreOrderTraverse----\n");
         PreOrderTraverse(trees[ptree], Print);
         printf("\n");
         getchar();getchar();
         break;
       case 18:
         printf("\n----InOrderTraverse----\n");
         InOrderTraverse(trees[ptree], Print);
         printf("\n");
         getchar();getchar();
         break;
       case 19:
         printf("\n----PostOrderTraverse----\n");
         PostOrderTraverse(trees[ptree], Print);
         printf("\n");
         getchar();getchar();
         break;
       case 20:
         printf("\n----LevelOrderTraverse----\n");
         LevelOrderTraverse(trees[ptree], Print);
         printf("\n");
         getchar();getchar();
         break;
       case 21:
         printf("\n----AllTree----\n");
         for(i = 0; i < TREE_MAXN; i++)
         {
             if(trees[i] != NULL)printf("tree%d depth %d\n", i + 1,trees[i]->depth);
         }
         getchar();getchar();
         break;
       case 22:
         printf("\n----ChangeTree----\n");
         printf("Please enter the tree number you want: ");
         scanf("%d", &id);
         ptree = id - 1;
         printf("\nYou have changed current tree.\n");
         getchar();getchar();
         break;
       case 23:
         printf("\n----SaveTree----\n");
         printf("Please enter the list file name you want to save:\n");
         scanf("%s", filename);

         pFile = fopen(filename, "w");
         PreOrderSave(trees[ptree], Save);

         fclose(pFile);
         getchar();
         break;
       case 24:
         printf("\n----Load Tree----\n");
         DestroyBiTree(trees[ptree]);
         printf("Please enter the tree file name:\n");
         scanf("%s", filename);
         if(freopen(filename, "r", stdin) == NULL)
         {
             printf("can not open the file!\n");
             freopen("CON", "r", stdin);
             getchar();
             break;
         }

         CreateBiTree(trees[ptree], trees[ptree]);
         printf("You have load tree.\n");

         freopen("CON", "r", stdin);
         getchar();
         break;

	   case 0:
         break;
       default:
         break;
	}//end of switch
  }//end of while
  printf("\nWelcome to this system next time！\n");
  return 0;
}//end of main()

bool InitBiTree(BiTree *T)
{
    if(T != NULL)return false;
    T = (BiTree *)malloc(sizeof(BiTree));
    return T == NULL;
}
bool DestroyBiTree(BiTree *T)
{
    if(T == NULL)return false;
    FreeBiTree(T);
    return true;
}
bool ClearBiTree(BiTree *T)
{
    if(T == NULL)return false;
    FreeBiTree(T->lchild);
    FreeBiTree(T->rchild);
    T->lchild = T->rchild = NULL;
    T->depth = 0;
    return true;
}
bool Print(ElemType e)
{
    std::cout << e.ToString();
    return true;
}
bool Save(BiTNode *T)
{
    if(T && T->depth > 0)
        fprintf(pFile, "%d %c\n", T->data.key, T->data.value);
    else
        fprintf(pFile, "0\n");
    return true;
}

