#include <stdio.h>
#define Unit 14
#define Chinese 10
#define Math 11
#define English 12
#define Average 13
#define N 3
extern "C" void CalcAverage(void);
extern "C" void Sort(void);

char BUF[N * Unit];

// debug/default data
char students[] = "wangwu\0   \x64\x55\x50\0lisi\0     \x50\x64\x46\0jiangzr\0  \x55\x55\x64\0";

// for unit testing
void Init()
{
    int i;

    for(i = 0; i < N * Unit; i++)
        BUF[i] = students[i];

}

char GetByteInt(char *s)
{
    int i = 0, k = 1;
    char ans = '\0';
    while(s[i + 1] != '\0')i++;
    while(i >= 0)
    {
        ans += (s[i] - '0') * k;
        k *= 10;
        i--;
    }
    return ans;
}

void DataEntry()
{
    char score[4];
    char *start = BUF;
    int i;

    for(i = 0; i < N; i++)
    {
        printf("Please enter the name of student : \n");
        scanf("%s", start);

        printf("Please enter the Chinese score of student : \n");
        scanf("%s", score);
        start[Chinese] = GetByteInt(score);

        printf("Please enter the Math score of student : \n");
        scanf("%s", score);
        start[Math] = GetByteInt(score);

        printf("Please enter the English score of student : \n");
        scanf("%s", score);
        start[English] = GetByteInt(score);

        start += Unit;
    }
}

void PrintReport()
{
    //char score[2] = {' ', '\0'};
    char *start = BUF;
    int i;

    printf("Name   Chinese   Math   English   Average \n");
    for(i = 0; i < N; i++)
    {
        printf("%s\t", start);

        printf("%d\t", (int)start[Chinese]);
        printf("%d\t", (int)start[Math]);
        printf("%d\t", (int)start[English]);
        printf("%d\n", (int)start[Average]);

        start += Unit;
    }
    printf("\n");
}

void PrintMenu()
{
    printf("1 Enter names and scores of student\n");
    printf("2 Calc average score of every student\n");
    printf("3 Sorting students by score from high to low\n");
    printf("4 Print score report\n");
    printf("5 Exit\n\n");
}

int main(){
    char op;

    Init();
    PrintMenu();

    scanf("%c", &op);
    while(op != '5')
    {
        switch(op)
        {
            case '1':
                DataEntry();
                break;
            case '2':
                CalcAverage();
                break;
            case '3':
                Sort();
                break;
            case '4':
                PrintReport();
                break;
            case '5':
                break;
            default:
                break;
        }
        scanf("%c", &op);
    }


	return 0;
}
