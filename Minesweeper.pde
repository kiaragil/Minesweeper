import de.bezier.guido.*;
public  int YROWS = 30;
public  int XCOL = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); 
private ArrayList <MSButton> messageSpace = new ArrayList <MSButton>(); 
private boolean gameOver = false;
private boolean win = false;
void setup (){
  size(600, 600);
  textAlign(CENTER, CENTER);  
  // make the manager
  Interactive.make( this ); 
  buttons = new MSButton[YROWS][XCOL];
  for (int r=0; r<YROWS; r++){
    for (int c=0; c<XCOL; c++){
      buttons[r][c] = new MSButton(r, c);
    }
  }
  setBombs();
}


public void draw (){
  if (isWon()){
    WinnerWinnerChickenDinner();
  }
}

public void setBombs(){
  while (bombs.size ()<50){
    int row = (int)(Math.random()*YROWS);
    int col = (int)(Math.random()*XCOL);
    if (!bombs.contains(buttons[row][col])){
      bombs.add(buttons[row][col]);
    }
  }
}

public boolean isWon(){
    for (int r = 0; r < YROWS; r++){
      for (int c = 0; c < XCOL; c++){
          if(!bombs.contains(buttons[r][c]) && !buttons[r][c].isClicked()){ return false;}
      }
    }
  return true;
}
public void youLose(){
  gameOver = true;
  for (int r = 0; r < YROWS; r++){
    for (int c = 0; c < XCOL; c++){
      if (bombs.contains(buttons[r][c])){ buttons[r][c].setLabel("B"); }
    }
  }
  String message = new String("GAME OVER!");
  for (int i = 0; i < message.length (); i++ )
  {
    if (!messageSpace.contains(buttons[(YROWS/2)-1][i+5]))
        {
          messageSpace.add(buttons[(YROWS/2)-1][i+5]);
        }
    buttons[(YROWS/2)-1][i+5].clicked = true;
    buttons[(YROWS/2)-1][i+5].marked = false;
    buttons[(YROWS/2)-1][i+5].setLabel(message.substring(i, i+1));
  }
}
public void WinnerWinnerChickenDinner(){
  win = true;
  for (int r = 0; r < YROWS; r++){
    for (int c = 0; c < XCOL; c++){ bombs.remove(buttons[r][c]);}
  }
  String message = new String("WINNER!");
  for (int i = 0; i < message.length (); i++ ){
    buttons[(YROWS/2)-1][i+5].clicked = true;
    buttons[(YROWS/2)-1][i+5].marked = false;
    if (!messageSpace.contains(buttons[(YROWS/2)-1][i+5])){
      messageSpace.add(buttons[(YROWS/2)-1][i+5]);
    }
    buttons[(YROWS/2)-1][i+5].setLabel(message.substring(i, i+1));
  }
}

public class MSButton{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc ){
    width = 600/XCOL;
    height = 600/YROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked(){ return marked;}
  public boolean isClicked(){ return clicked;}

  public void mousePressed(){
    if (gameOver){ return;}
    if (mouseButton == LEFT && !gameOver && !win && !isMarked()){ clicked = true;}
    if (mouseButton == RIGHT && !gameOver && !win && !isClicked()){ marked=!marked;}
    else if (bombs.contains(this) && !marked){ youLose();}
    else if (countBombs(r, c)>0 && !isMarked()){ label = "" + countBombs(r, c);}
    else if(countBombs(r,c)>0 && isMarked()){ clicked=!clicked;}

    else{
      if (isValid(r, c-1) && !buttons[r][c-1].clicked){
        buttons[r][c-1].mousePressed();
      }
      if (isValid(r, c+1) && !buttons[r][c+1].clicked){
        buttons[r][c+1].mousePressed();
      }
      if (isValid(r-1, c) && !buttons[r-1][c].clicked){
        buttons[r-1][c].mousePressed();
      }
      if (isValid(r+1, c) && !buttons[r+1][c].clicked){
        buttons[r+1][c].mousePressed();
      }
      if (isValid(r-1, c-1) && !buttons[r-1][c-1].clicked){
        buttons[r-1][c-1].mousePressed();
      }
      if (isValid(r+1, c+1) && !buttons[r+1][c+1].clicked){
        buttons[r+1][c+1].mousePressed();
      }  
      if (isValid(r+1, c-1) && !buttons[r+1][c-1].clicked){
        buttons[r+1][c-1].mousePressed();
      }
      if (isValid(r-1, c+1) && !buttons[r-1][c+1].clicked){
        buttons[r-1][c+1].mousePressed();
      }
    }
  }

  public void draw (){    
    if (marked){
      fill(117,127,156);
      ellipse(x+width/2, y+height/2, width/2, height/2); //marking daBombs
    } 
    else if (clicked && bombs.contains(this) && !messageSpace.contains(this)){
      fill(181,0,42);
      rect(x, y, width, height);
      } //bomb clicked
    else if (clicked && messageSpace.contains(this)){
      fill(16,1,35);
      rect(x, y, width, height); //message
    } 
    else if (clicked){
      fill(118, 63, 101);
      rect(x, y, width, height); //fill clicked

    } 
    else{
      fill(101,103,94);
      rect(x, y, width, height); //board
    }

    if (gameOver && !win){
        fill(255);
        text(label, x+width/2, y+height);
    } 

    else if (!gameOver && win){
      fill(100, 255, 246);
      text(label, x+ width/4, y+height);
    } 

    else{
      
      fill(225,255,200);
      text(label, x+width/2, y+height);
    }

  }

  public void setLabel(String newLabel){
    label = newLabel;
  }
  public boolean isValid(int r, int c){
    if (r >= 0 && r < YROWS && c >= 0 && c < XCOL){
      return true;
    }

    return false;
  }
  
  public int countBombs(int row, int col){
    int numBombs = 0;

    if (isValid(row-1, col) && bombs.contains(buttons[row-1][col])){ numBombs++;}
    if (isValid(row+1, col) && bombs.contains(buttons[row+1][col])){ numBombs++;}
    if (isValid(row, col-1) && bombs.contains(buttons[row][col-1])){ numBombs++;}
    if (isValid(row, col+1) && bombs.contains(buttons[row][col+1])){ numBombs++;}
    if (isValid(row+1, col-1) && bombs.contains(buttons[row+1][col-1])){ numBombs++;}
    if (isValid(row-1, col+1) && bombs.contains(buttons[row-1][col+1])){ numBombs++;}
    if (isValid(row+1, col+1) && bombs.contains(buttons[row+1][col+1])){ numBombs++;}
    if (isValid(row-1, col-1) && bombs.contains(buttons[row-1][col-1])){ numBombs++;}
    
    return numBombs;
  }
}

public void keyPressed(){
    gameOver = false;
    win = false;
    for(int r = 0; r < YROWS; r++){
      for(int c = 0; c < XCOL; c++){
          bombs.remove(buttons[r][c]);
          messageSpace.remove(buttons[r][c]);
          buttons[r][c].marked = false;
          buttons[r][c].clicked = false;
          buttons[r][c].setLabel(" ");
        }
    setBombs(); 
    }
}
