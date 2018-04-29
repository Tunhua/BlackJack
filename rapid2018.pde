// ライブラリを読み込み（よくわからなかったらとりあえずそのままにしておいてください）
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// ゲームシステム用変数（よくわからなかったらとりあえずそのままにしておいてください）
// キーボード入力管理用のKeyboardManager
KeyboardManager keyman;
// フォント（環境によって違ったらヤバそうなので一応スケッチに付属させたVLゴシックを使うことにしている）
PFont font;

// Minimライブラリ用の変数
Minim minim;
// ゲームシステム用変数ここまで


// 以下にグローバル変数を宣言します
ArrayList<Trump> playertrump = new ArrayList<Trump>();
ArrayList<Trump> dealertrump = new ArrayList<Trump>();
Trump gettrump;
boolean beforez=false;
boolean beforec=false;
boolean finish=false;
boolean[][]  exist=new boolean[13][4];
int psum=0;
int count=0;
// グローバル変数ここまで


// スケッチ実行時に最初に１度だけ実行されます
void setup() {
  // ゲームの初期化
  // ゲームシステムの初期化（よくわからなかったらとりあえずそのままにしておいてください）
  print("文字列描画を初期化中......");
  // KeyboardManagerのインスタンスを作成
  keyman = new KeyboardManager();
  // フォントを読み込む
  font = createFont("fonts/VL-PGothic-Regular.ttf", 24);
  if(font == null) {
    // ここで読み込めていない場合はWindowsと同じで'\'で区切るのかもしれない
    font = createFont("fonts\\VL-PGothic-Regular.ttf", 24);
  }
  textFont(font);
  // 文字描画位置を設定する（座標が左上）
  textAlign(LEFT, TOP);
  println("\t[ OK ]");
  
  print("ビデオを初期化中......");
  // 画面サイズを設定（左から順に幅と高さ）
  size(800, 600);
  // フレームレート（単位はフレーム毎秒）
  // １秒間にここに指定した回数だけdraw()が呼ばれる
  frameRate(30);
  println("\t[ OK ]");
  
  print("サウンドシステムを初期化中......");
  // 音声ライブラリ初期化
  minim = new Minim(this);
  println("\t[ OK ]");
  
  println("完了.");
  // ゲームシステムの初期化ここまで
  
  
  // 以下に追加の初期化処理を書きます
  for(int j = 0; j < 13; j++) {
    for(int k = 0; k < 4; k++) {
      exist[j][k] = true;
    }
  }
  
  playertrump.add(new Trump(0, 0));
  playertrump.add(new Trump(0, 0));
  dealertrump.add(new Trump(30, 10));
  dealertrump.add(new Trump(90, 10));
  

  // 初期化処理ここまで
}

// ゲームメインループ
void draw(){
  // キー入力情報の更新
  keyman.updateKeys();
  // 画面の消去（背景色をここで指定する）
  background(255, 255, 255);
  
  // 以下にゲームの処理を書きます
int dsum=0;
  
  if(!finish) {
    if(psum <= 21) {
      if (gettrump!=null) {
        gettrump.y += 10;
        if (gettrump.y >= height - 100) {
        playertrump.add(gettrump);
        gettrump=null;
        }
        else {
         fill(gettrump.c);
         rect(gettrump.x,gettrump.y, w, h);
         fill(0);
         textSize(32);
         rText(str(gettrump.num), gettrump.x + w/2, gettrump.y + h/2, 0);
        }
      }
    else {
      fill(0);
      textSize(32);
      rText("Press Z to Draw, Press C to Finish", width/2, height/2,0);
      if (keyman.getKey("c") && !beforec) {
           finish=true;
      }
      else if (keyman.getKey("z") && !beforez) {
        gettrump = new Trump(width/2, -60);
      }
    }
  }
   else {
      fill(0);
      textSize(40);
      rText("LOSE",width/2, height/2,0);
      if(keyman.getKey("r")){Reset();}
   }
    Trump dealer1=dealertrump.get(0);
     fill(dealer1.c);
     rect(dealer1.x, dealer1.y, w, h);
     fill(0);
     textSize(32);
     rText(str(dealer1.num), dealer1.x + w/2, dealer1.y + h/2, 0);
     
     Trump dealer2=dealertrump.get(1);
     fill(0);
     rect(dealer2.x, dealer2.y, w, h);
}
else {
  
  int Anum=0;
  for (int j = 0; j < dealertrump.size(); j++) {
    Trump trump = dealertrump.get(j);
    trump.x = 30 + 60 * j;
    trump.y=10;
    fill(trump.c);
    rect(trump.x, trump.y, w, h);
    fill(0);
    textSize(32);
    rText(str(trump.num), trump.x + w/2, trump.y + h/2, 0);
    if(trump.num>=10){
      dsum+=10;
    }
    else{
      dsum += trump.num;
      if(trump.num==1){Anum++;}
    }
  }
      for(int j=0;j<Anum;j++){
        if(dsum+10<=21){dsum+=10;}
      }

  fill(0);
  textSize(32);
  rText(str(dsum), width-50, height/2, 0);
  if (dsum >= 17 && dsum <= 21) {
    
    int pPoint=21-psum;
    int dPoint=21-dsum;
    fill(0);
    textSize(40);
    if (pPoint <= dPoint) {
      rText("WIN",width/2, height/2,0);
      if(keyman.getKey("r")){Reset();}
    }
    else{
      rText("LOSE",width/2,height/2,0);
      if(keyman.getKey("r")){Reset();}
    }
  }
  else if(dsum >21) {
    fill(0);
    textSize(40);
    rText("WIN",width/2,height/2,0);
    if(keyman.getKey("r")){Reset();}
  }
  else {
     if (count >= 10) {
      dealertrump.add(new Trump(0,0));
      count = 0;
    }
  }
  
  count++;
}

int Anum=0;
psum=0;
 for (int j = 0; j < playertrump.size(); j++) {
   Trump trump = playertrump.get(j);
   trump.x = 30 + 60 * j;
   trump.y = height-100;
   fill(trump.c);
   rect(trump.x, trump.y, w, h);
   fill(0);
   textSize(32);
   rText(str(trump.num), trump.x + w/2, trump.y + h/2, 0);
   if (trump.num >= 10) {
     psum += 10;
   }
   else {
   psum+=trump.num;
   if(trump.num==1){Anum++;}
   }
 }
 for(int j=0;j<Anum;j++){
   if(psum+10<=21){psum+=10;}
 }
 
 beforez=keyman.getKey("z");
 beforec=keyman.getKey("c");
 fill(0);
 textSize(32);
 text(str(psum), 30, height/2);
 
}
  // ゲームの処理ここまで

float w=50;
float h=80;
class Trump {
  float x, y;
  int num;
  color c;
  public Trump(float x, float y) {
    this.x = x;
    this.y = y;
    this.num = (int)random(1, 14);
    this.c = (int)random(4);
    while(!exist[this.num-1][this.c]){
      this.num = (int)random(1, 14);
      this.c = (int)random(4);
    }
    switch(c){
      case 0:
        this.c=color(0,0,255);
        break;
      case 1:
        this.c=color(255, 0, 0);
        break;
      case 2:
        this.c=color(0, 255, 0);
        break;
      case 3:
        this.c=color(255, 255, 255);
        break;
      
       
    }
  }
}
void Reset(){
   for(int j = 0; j < 13; j++) {
    for(int k = 0; k < 4; k++) {
      exist[j][k] = true;
    }
  }
 finish=false;
psum=0;
count=0;
  
    playertrump.clear();
  dealertrump.clear();
  
  playertrump.add(new Trump(0, 0));
  playertrump.add(new Trump(0, 0));
  dealertrump.add(new Trump(30, 10));
  dealertrump.add(new Trump(90, 10));
  
}

// 何かキーが押されたときに行う処理を書きます
void keyPressed() {
  // 押されたキーを確認する（KeyboardManager keymanを動作させるために必要）
  keyman.keyPressedHook();
}
// 何かキーが離されたときに行う処理を書きます
void keyReleased() {
  // 離されたキーを確認する（KeyboardManager keymanを動作させるために必要）
  keyman.keyReleasedHook();
}
