class game
{
  //data: current level, score, time
  int level, score;
  float t, t_last, tremained, checkmarktime, crosstime;
  int nanswers; //number of questions answered
  int correctinarow; //number of problems solved right in a row
  int[] levels; //levels for each question from 0 to last one
  int[] questionIds; //ids of questions that were asked
  boolean[] answers; //array of answers (wrong or right)
  int MAXQ;
  boolean ispaused;
  problemset pset;
  XML prob;
  int resultsprinted;
  Maxim maxim;
  AudioPlayer good;
  AudioPlayer bad;
  AudioPlayer metronome;
  AudioPlayer finish;
  
  game(int l)
  {
    level = l;
    score = 0; //score starts at 0
    t = millis(); //time in milliseconds since applet started
    t_last = t;
    tremained = 30;
    checkmarktime = crosstime=t-1000;
    nanswers = 0; //user answered 0 questions so far
    correctinarow = 0;
    ispaused = 0;
    questionIds = new int[MAXQ];
    answers = new boolean[MAXQ];
    levels = new int[MAXQ];
    pset = new problemset("level_1.xml",level);
    prob = pset.getNextProblem();
    resultsprinted=0;
    //sound
    maxim = new Maxim(this);
    good = maxim.loadFile("good.wav");
    //good.setLooping(false);
    bad = maxim.loadFile("bad.wav");
    //bad.setLooping(false);
    metronome = maxim.loadFile("metronome2.wav");
    //metronome.setLooping(true);
    finish = maxim.loadFile("finish.wav");
    //finish.setLooping(false);
    coin = maxim.loadFile("coin.wav");
  }
  
  game()
  {
    this.game(1);
  }
  
  void display()
  {
    int secs, mins, i;
    //обновляем значение tremained
    t = millis();
    if (!ispaused){tremained = tremained - (t - t_last) / 1000;}
    if (tremained < 5 && tremained > 0) {metronome.play();}
    background(#A4F1FA);
    rectMode(CENTER);
    //прямоугольники сверху
    //показываем время, уровень, очки, количество решенных подряд
    fill(#4C949D);
    noStroke();
    rect(40,40,80,80);
    rect(320,40,230,80);
    rect(560,40,230,80);
    rect(800,40,230,80);
    stroke(0);
    strokeWeight(8);
    strokeCap(ROUND);
    line(30,20,30,60);
    line(50,20,50,60);
    noStroke();
    fill(0);
    
    textSize(48);
    textAlign(LEFT,CENTER);
    mins = (int) (tremained / 60);
    secs = (int) tremained - mins * 60;
    
    text("Time: " + mins + ":"+secs, 210, 40);
    text("Level: " + level, 450, 40);
    text("Score: " + score, 690, 40);
    text("+30 seconds", 210, 120);
    
    stroke(#FFA536);
    strokeWeight(2);
    fill(#FFA536);
    for (i=0;i<5;i++)
    {
      if (i >= correctinarow)
      {noFill();}
      ellipse(660+60*i,120,40,40);
    }
    
    //рисуем кнопки
    noStroke();
    fill(#5AC630);
    rect(240,520,320,80);
    fill(#D10B0B);
    rect(720,520,320,80);
    fill(255);
    textSize(60);
    textAlign(CENTER,CENTER);
    text("Yes", 240, 520);
    text("No", 720, 520);
    textSize(48);
    
   //показываем условие !!!!!!!!!!!!!!
   fill(204);
   rect(480,280,800,240);
   fill(0);
   textSize(16);
   //text(prob.getString("answer")+prob.getInt("id"),480,280);
   text(prob.getContent(),480,280);
   //document.getElementById("forma1").innerHTML=prob.innerHTML;
   
   //рисуем крестик или галочку с угасанием
   
   if (checkmarktime > t-1000){
     drawcheckmark((checkmarktime-t+1000)*0.255);
   }
   else if (crosstime>t-1000){
     drawcross((crosstime-t+1000)*0.255);
   }
   
   if (ispaused) {
      fill(204,200);
      rect(width/2,height/2,width,height);
      fill(255);
      ellipse(width/2,height/2,180,180);
      stroke(0);
      strokeWeight(20);
      line(width/2-20,height/2-60,width/2-20,height/2+60);
      line(width/2+20,height/2-60,width/2+20,height/2+60);
      
    }
   
   t_last = t;
  }
  
  void drawcheckmark(float opac)
  {
  fill(#5AC630,opac);       
        pushMatrix();
            rectMode(CENTER);
            translate(width/2,height/2);
            scale(10);
            rotate(-HALF_PI/2); rect(15,0,40,10);
            rotate(-HALF_PI); rect(10,0,10,10);
        popMatrix();
  }
  
  void drawcross(float opac)
  {
  fill(#D10B0B,opac);
        pushMatrix();
            translate(width/2,height/2);
            scale(10);
            rotate(HALF_PI/2); rect(0,0,40,10);
            rotate(HALF_PI); rect(12.5,0,15,10); rect(-12.5,0,15,10);
        popMatrix();
  }
  
  int checkbuttons(int x, int y)
  {
    if (x>560 && x<880 && y<560 && y>480) {return 2;}
    else if (x>80 && x<400 && y<560 && y>480) {return 1;}
    else if (x>0 && x<80 && y<80 && y>0) {return 3;} //pause button
    else return 0;
  }
  
  void buttonpressed(int butt) 
  //1 corresponds to Yes button, 2 corresponds to No button, 3 - pause
  {
    //pick a new problem according to
    boolean ans;
    
      bad.stop();
      good.stop();
      coin.stop();
    if (ispaused){ ispaused = !ispaused; return; }
    if (butt == 3) { ispaused = !ispaused; return; }
    else if (butt == 1) { ans = prob.getString("answer").equals("Yes");}
    else if (butt == 2) { ans = prob.getString("answer").equals("No");}
    else { return; }
    if (ans){
      levels[nanswers] = level;
      questionIds[nanswers] = prob.getInt("id");
      answers[nanswers] = true;
      checkmarktime = t;
      correctinarow++;
      score += (int)100 * exp( log(1.2) * (level - 1) );
      
      
      if (correctinarow == 5){
        correctinarow = 0;
        score += (int)100 * exp( log(1.2) * (level - 1) );
        level++;
        pset.level = level;
        pset.loadProblems();
        tremained = tremained + 30;
        coin.play();
      }
      else{good.play();}
    }
    else {
      levels[nanswers] = level;
      questionIds[nanswers] = prob.getInt("id");
      answers[nanswers] = false;
      crosstime = t;
      correctinarow = 0;
      tremained = tremained - 5;
      
      bad.play();
    }
    nanswers++;
    prob = pset.getNextProblem();
    return;
  }
  
  void congrats()
  {
    
    background(125);
    rectMode(CENTER);
    fill(204);
    stroke(0);
    rect(width/2,height/2,500,200);
    fill(0);
    textMode(CENTER);
    textSize(24);
    t=0;
    for (int i=0; i<nanswers;i++){
     if(answers[i]) {t++;}
    }
    text("Good job! \n You earned "+(int)score+" points \n Highest level is "+level+"\n You solved correctly " +t+" problems" ,width/2,height/2);//draw congratulations screen
    if(!resultsprinted){
     String res[] = loadStrings("results.txt");
     saveStrings("results.txt", concat(res,(int)score));
     res = loadStrings("results.txt");
     //println("there are " + res.length + " lines");
     for (int i=0;i<res.length;i++){println(": "+res[i] );}
     resultsprinted=true;
     
     finish.play();
    }
  }
}



