
Mat bicubique(Mat image_BR,int res)
{
   
   int width= image_BR.cols*res;
   int height =  image_BR.rows*res;
   int N=0,D=0,X=0,A=0;
   signed int a,b;
   int Q;
   int P1[4][3];
   float q;
   int tab_ref[4],tab_ref0[4][2],tab_ref1[4][2],tab_ref2[4][2],tab_ref3[8][2];
   Mat image_HR;
   image_HR.create(height,width,CV_8UC3);
   Mat image_HR_bis;
   image_HR_bis.create(height,width,CV_8UC3);
 
   // échantillonnage de l'image
   for (int i=0;i<(height/res);i++)
   {
       for (int j=0;j<(width/res);j++)
       {
            for (int k=0;k<3;k++)
           {
              image_HR_bis.at<Vec3b>(i*res,j*res)[k] = image_BR.at<Vec3b>(i,j)[k]; // Placer dans une image HR BIS l'image BR multipliée par la résolution 
              image_HR.at<Vec3b>(i*res,j*res)[k] = image_BR.at<Vec3b>(i,j)[k];
           }   
       }
   }
    //image_HR=image_HR_bis; //Prendre une image échantillonnée de référence sans modifier l'image finale
    
    for (int I=3;I<height-(res-1);I=I+res) // Parcourir les pixels de l'image HR BIS
    {
       for (int J=3;J<width-(res-1);J=J+res)
       {
            int P=image_HR_bis.at<Vec3b>(I,J)[0];N=0;
            if(P<=0) // Utiliser les pixels qui n'ont pas de valeur
            {
                for(a=I-(2*res-1);a<I+(2*res);a=a+2)
                {
                    if((a<height) && (a>-1)) //Si on ne sort pas de l'image
                    {
                        for ( b=J-(2*res-1);b<J+(2*res);b=b+2) //Recherche des 16 pixels connus sur la colonne 
                        {
                            if ((b>-1) && (b<width))  //Si on ne sort pas de l'image  
                            { 
                                int G=image_HR_bis.at<Vec3b>(a,b)[0];
                                if((G>=0) && (N<16)) // ranger les pixels connus dans un tableau
                                {
                                    if(N<4)
                                    {
                                        tab_ref0[N][0] = a; 
                                        tab_ref0[N][1] = b;
                                    }
                                    else if ((N>3) && (N<8))
                                    {
                                        tab_ref1[N-4][0] = a; 
                                        tab_ref1[N-4][1] = b;
                                    }
                                    else if ((N>7) && (N<12))
                                    {
                                        tab_ref2[N-8][0] = a; 
                                        tab_ref2[N-8][1] = b;
                                    }
                                    else
                                    {
                                        tab_ref3[N-12][0] = a; 
                                        tab_ref3[N-12][1] = b;
                                    }
                                   /* std::cout<<"I="<<std::endl;
                                    std::cout<<I<<std::endl;
                                    std::cout<<"J="<<std::endl;
                                    std::cout<<J<<std::endl;
                                    std::cout<<"N="<<std::endl;
                                    std::cout<<N<<std::endl;
                                    std::cout<<"A et B ="<<std::endl;
                                    std::cout<<a<<std::endl;
                                    std::cout<<b<<std::endl;*/
                                    N++; // N représente le nombre de pixels connus autour du pixel inconnu
                                }
                            }
                        }
                    }
                } 
                    //----------cubique---------- 
                  
                for (int R=0;R<4;R++)
                {
                    float p=1.0;
                    for(int T=0;T<4;T++)
                    {
                        if(R!=T)
                        {
                            p = p* (J - tab_ref0[T][1])/(tab_ref0[R][1] - tab_ref0[T][1]);
                        }
                    }
                    for ( A=0;A<3;A++)
                    {
                        Q=round(p * image_HR_bis.at<Vec3b>(tab_ref0[R][0],tab_ref0[R][1])[A]);
                        image_HR_bis.at<Vec3b>(tab_ref0[0][0],J)[A] = image_HR_bis.at<Vec3b>(tab_ref0[0][0],J)[A] + Q;
                    }
                }
                tab_ref[0]=tab_ref0[0][0];
                for (int R=0;R<4;R++) 
                {
                    float p=1.0;
                    for(int T=0;T<4;T++)
                    {
                        if(R!=T)
                        {
                            p = p* (J - tab_ref1[T][1])/(tab_ref1[R][1] - tab_ref1[T][1]);
                        }
                    }
                    for ( A=0;A<3;A++)
                    {
                        Q=round(p * image_HR_bis.at<Vec3b>(tab_ref1[R][0],tab_ref1[R][1])[A]);
                        image_HR_bis.at<Vec3b>(tab_ref1[0][0],J)[A] = image_HR_bis.at<Vec3b>(tab_ref1[0][0],J)[A] + Q ;
                    } 
                } 
                tab_ref[1]=tab_ref1[0][0];
                for (int R=0;R<4;R++) 
                {
                    float p=1.0;
                    for(int T=0;T<4;T++)
                    {
                        if(R!=T)
                        {
                            p = p* (J - tab_ref2[T][1])/(tab_ref1[R][1] - tab_ref1[T][1]);
                        }
                    }
                    for ( A=0;A<3;A++)
                    {
                        Q=round(p * image_HR_bis.at<Vec3b>(tab_ref2[R][0],tab_ref2[R][1])[A]);
                        image_HR_bis.at<Vec3b>(tab_ref2[0][0],J)[A] = image_HR_bis.at<Vec3b>(tab_ref2[0][0],J)[A] + Q ;
                    } 
                }   
                tab_ref[2]=tab_ref2[0][0];
                for (int R=0;R<4;R++) 
                {
                    float p=1.0;
                    for(int T=0;T<4;T++)
                    {
                        if(R!=T)
                        {
                            p = p* (J - tab_ref3[T][1])/(tab_ref3[R][1] - tab_ref3[T][1]);
                        }
                    }
                    for ( A=0;A<3;A++)
                    {
                        Q=round(p * image_HR_bis.at<Vec3b>(tab_ref3[R][0],tab_ref3[R][1])[A]);
                        image_HR_bis.at<Vec3b>(tab_ref3[0][0],J)[A] = image_HR_bis.at<Vec3b>(tab_ref3[0][0],J)[A] + Q ;
                    } 
                } 
                tab_ref[3]=tab_ref3[0][0];
                //----------------------------------------------------
                for (int R=0;R<4;R++) 
                {
                    float p=1.0;
                    for(int T=0;T<4;T++)
                    {
                        if(R!=T)
                        {
                            p = p* (I - tab_ref[T])/(tab_ref[R] - tab_ref[T]);
                        }
                    }
                    for ( A=0;A<3;A++)
                    {
                        Q=round(p * image_HR_bis.at<Vec3b>(tab_ref[R],J)[A]);
                        image_HR.at<Vec3b>(I,J)[A] = image_HR.at<Vec3b>(I,J)[A] + Q ;
                    } 
                } 
                for(int O=0;O<4;O++)
                {
                    for(int Z=0;Z<2;Z++)
                    {    
                        for(int A=0;A<3;A++)
                        { 
                            image_HR_bis.at<Vec3b>(tab_ref0[O][Z],J)[A]=0;
                            image_HR_bis.at<Vec3b>(tab_ref1[O][Z],J)[A]=0;
                            image_HR_bis.at<Vec3b>(tab_ref2[O][Z],J)[A]=0;
                            image_HR_bis.at<Vec3b>(tab_ref3[O][Z],J)[A]=0;
                        }
                    }    
                }
            }
        }   
    }
  //image_HR=noirBlanc(image_HR); // mettre l'image finale en noir et blanc pour mieux voir la différence de précision
    return image_HR;
}     
