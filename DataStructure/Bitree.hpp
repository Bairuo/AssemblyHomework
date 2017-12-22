/*
 * Bitree.hpp
 *
 * Definitions of types and prototypes of functions for Binary Tree On Chain Structure.
 *
 * NOTE: The file manipulation functions provided by Bairuo, IS1603 jzr.
 *
 */

#ifndef Bitree_H_
#define Bitree_H_

#include <malloc.h>
#include <stdlib.h>
#include <queue>
#include <algorithm>


#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR -1
#define INFEASTABLE -2
#define OVERFLOW -3

typedef int status;

struct TreeData{
    int key;
    char value;

    std::string ToString()
    {
        std::string s = "";
        return s + value + " ";
    }

    bool operator == (TreeData &b)
    {
        return key == b.key;
    }

    bool operator == (int b)
    {
        return key == b;
    }
};

typedef TreeData ElemType;
typedef int ElemKey;
typedef char ElemValue;

typedef struct BiTNode{
	ElemType data;
	int depth = 0;     // c++ 11
	struct BiTNode *parent, *lchild, *rchild;
}BiTNode, BiTree;


int CreateBiTree(BiTree* &T, BiTree* &Parent)
{
    ElemKey key;
    ElemValue ch;
    scanf("%d", &key);

    if(key == 0)
    {
        T = NULL;
        return 0;
    }
    else{
        ch = getchar();
        while(ch == ' ')ch = getchar();

        if(!(T = (BiTNode *)malloc(sizeof(BiTNode))))
        {
            return -1;
        }
        T->parent = Parent;
        T->data.key = key;
        T->data.value = ch;

        int depth1 = CreateBiTree(T->lchild, T);
        int depth2 = CreateBiTree(T->rchild, T);

        if(depth1 >= 0 && depth2 >= 0)
        {
            return T->depth = std::max(depth1, depth2) + 1;
        }
        else
        {
            return -1;
        }
    }
}
status FreeBiTree(BiTree* &T)
{
    if(T)
    {
        FreeBiTree(T->lchild);
        FreeBiTree(T->rchild);
        free(T);
        T = NULL;
    }
    return OK;  // 书上status状态设计得很迷
}
bool BiTreeEmpty(BiTree *T)
{
    return T->depth == 0;
}
int BiTreeDepth(BiTree *T)
{
    return T->depth;
}

BiTNode *Get(BiTree *T, ElemKey e)
{
    if(T == NULL || T->data == e)
        return T;
    else
    {
        BiTNode *T1 = Get(T->lchild, e);
        if(T1 != NULL)return T1;
        BiTNode *T2 = Get(T->rchild, e);
        if(T2 != NULL)return T2;
    }
}

ElemValue Value(BiTree *T, ElemKey e)
{
    BiTNode *t = Get(T, e);
    if(t == NULL)
    {
        printf("can not get the node!\n");
        return 0;
    }
    return t->data.value;
}
status Assign(BiTree *T, ElemKey e, ElemValue value)
{
    BiTNode *t = Get(T, e);
    if(t == NULL)
    {
        printf("Can not get the node!\n");
        return FALSE;
    }
    t->data.value = value;
    return OK;
}
BiTNode *Parent(BiTree *T, ElemKey e)
{
    BiTNode *t = Get(T, e);
    if(t == NULL)
    {
        printf("Can not get the node!\n");
        return NULL;
    }

    if(t == t->parent)
    {
        printf("Root node.\n");
        return NULL;
    }

    printf("You have get the node(node data %c)\n", t->parent->data.value);
    return t->parent;
}
BiTNode *LeftChild(BiTree *T, ElemKey e)
{
    BiTNode *t = Get(T, e);
    if(t == NULL)
    {
        printf("Can not get the node!\n");
        return NULL;
    }

    if(t->lchild == NULL)
    {
        printf("Have no left node.\n");
        return NULL;
    }

    printf("You have get the node(node data %c)\n", t->lchild->data.value);
    return t->lchild;
}
BiTNode *RightChild(BiTree *T, ElemKey e)
{
    BiTNode *t = Get(T, e);
    if(t == NULL)
    {
        printf("Can not get the node!\n");
        return NULL;
    }

    if(t->rchild == NULL)
    {
        printf("Have no right node.\n");
        return NULL;
    }

    printf("You have get the node(node data %c)\n", t->rchild->data.value);
    return t->rchild;
}
BiTNode *LeftSibling(BiTree *T, ElemKey e)
{
    BiTNode *t = Get(T, e);
    if(t == NULL)
    {
        printf("Can not get the node!\n");
        return NULL;
    }

    if(t->parent == t || t->parent->lchild == NULL || t->parent->lchild == t)
    {
        printf("Have no LeftSibling.\n");
        return NULL;
    }

    printf("You have get the node(node data %c)\n", t->parent->lchild->data.value);
    return t->parent->lchild;
}
BiTNode *RightSibling(BiTree *T, ElemKey e)
{
    BiTNode *t = Get(T, e);
    if(t == NULL)
    {
        printf("Can not get the node!\n");
        return NULL;
    }

    if(t->parent == t || t->parent->rchild == NULL || t->parent->rchild == t)
    {
        printf("Have no RightSibling.\n");
        return NULL;
    }

    printf("You have get the node(node data %c)\n", t->parent->rchild->data.value);
    return t->parent->rchild;
}
status InsertChild(BiTree *T, BiTNode *p, int LR, BiTree *son)
{
    if(LR == 0)p->lchild = son;
    else p->rchild = son;
    return OK;
}
status PreOrderSave(BiTree *T, bool(* Visit)(BiTNode *e))
{

    if(Visit(T))
    {
        if(T!= NULL)
        {
            PreOrderSave(T->lchild, Visit);
            PreOrderSave(T->rchild, Visit);
        }
    }
    return OK;

}
status PreOrderTraverse(BiTree *T, bool(* Visit)(ElemType e))
{
    if(T && T->depth > 0)
    {
        if(Visit(T->data))
            if(PreOrderTraverse(T->lchild, Visit) == OK)
                if(PreOrderTraverse(T->rchild, Visit) == OK)
                    return OK;
        return ERROR;
    }
    else
    {
        return OK;
    }
}
status InOrderTraverse(BiTree *T, bool(* Visit)(ElemType e))
{
    if(T && T->depth > 0)
    {
        if(InOrderTraverse(T->lchild, Visit) == OK)
            if(Visit(T->data))
                if(InOrderTraverse(T->rchild, Visit) == OK)
                    return OK;
        return ERROR;
    }
    else
    {
        return OK;
    }
}
status PostOrderTraverse(BiTree *T, bool(* Visit)(ElemType e))
{
    if(T && T->depth > 0)
    {
        if(PostOrderTraverse(T->lchild, Visit) == OK)
            if(PostOrderTraverse(T->rchild, Visit) == OK)
                if(Visit(T->data))
                    return OK;
        return ERROR;
    }
    else
    {
        return OK;
    }
}
status LevelOrderTraverse(BiTree *T, bool(* Visit)(ElemType e))
{
    std::queue<BiTNode *> q;
    q.push(T);
    while(!q.empty())
    {
        BiTree *t = q.front();
        Visit(t->data);
        q.pop();
        if(t->lchild != NULL)q.push(t->lchild);
        if(t->rchild != NULL)q.push(t->rchild);
    }
}

#endif // Bitree_H_
