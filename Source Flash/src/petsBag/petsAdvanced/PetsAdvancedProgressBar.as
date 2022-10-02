package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import petsBag.event.PetsAdvancedEvent;
   
   public class PetsAdvancedProgressBar extends Sprite implements Disposeable
   {
       
      
      private var _progressBg:Bitmap;
      
      private var _progressBar:Bitmap;
      
      protected var _progressTxt:FilterFrameText;
      
      private var _progressBarMask:Sprite;
      
      protected var _progressMc:MovieClip;
      
      protected var _currentExp:int;
      
      protected var _max:int;
      
      protected var _sumWidth:Number;
      
      public function PetsAdvancedProgressBar()
      {
         super();
         this.initView();
      }
      
      private function addEvent() : void
      {
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      protected function __enterFrame(param1:Event) : void
      {
         if(this._progressMc.currentFrame >= 25)
         {
            this._progressMc.stop();
            this._progressBar.visible = true;
            this._progressBg.visible = true;
            this._progressMc.visible = false;
            this.removeEvent();
            dispatchEvent(new PetsAdvancedEvent(PetsAdvancedEvent.PROGRESS_MOVIE_COMPLETE));
         }
      }
      
      private function initView() : void
      {
         if(PetsAdvancedManager.Instance.currentViewType == 1)
         {
            this._progressMc = ComponentFactory.Instance.creat("petsBag.risingStar.progressMc");
            this._progressBg = ComponentFactory.Instance.creat("petsBag.risingStar.petsBag.progressBg");
            this._progressBar = ComponentFactory.Instance.creat("petsBag.risingStar.petsBag.progressBar");
            this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.progressTxt");
            PositionUtils.setPos(this._progressTxt,"petsBag.risingStar.progressTxtPos");
         }
         else if(PetsAdvancedManager.Instance.currentViewType == 2)
         {
            this._progressMc = ComponentFactory.Instance.creat("petsBag.evolution.progressMc");
            this._progressBg = ComponentFactory.Instance.creat("petsBag.evolution.progressBg");
            this._progressBar = ComponentFactory.Instance.creat("petsBag.evolution.progressBar");
            this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.progressTxt");
            PositionUtils.setPos(this._progressTxt,"petsBag.ecolution.progressTxtPos");
         }
         else
         {
            this._progressMc = ComponentFactory.Instance.creat("petsBag.evolution.progressMc");
            this._progressBg = ComponentFactory.Instance.creat("assets.PetsBag.eatPets.expBarBg");
            this._progressBar = ComponentFactory.Instance.creat("assets.PetsBag.eatPets.expBar");
            this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.progressTxt");
            PositionUtils.setPos(this._progressTxt,"petsBag.eatPets.progressTxtPos");
         }
         addChild(this._progressMc);
         this._progressMc.stop();
         this._progressMc.visible = false;
         addChild(this._progressBg);
         addChild(this._progressBar);
         addChild(this._progressTxt);
         this._sumWidth = this._progressBar.width - 20;
         this._progressBarMask = new Sprite();
         this._progressBarMask.graphics.beginFill(16777215,1);
         this._progressBarMask.graphics.drawRect(0,0,this._sumWidth,this._progressBar.height);
         this._progressBarMask.graphics.endFill();
         this._progressBarMask.x = this._progressBar.x + 9;
         this._progressBarMask.y = this._progressBar.y;
         this._progressBar.cacheAsBitmap = true;
         this._progressBar.mask = this._progressBarMask;
         addChild(this._progressBarMask);
         this.setProgress(0);
      }
      
      public function setProgress(param1:Number, param2:Boolean = false) : void
      {
         this._currentExp = param1;
         if(param2)
         {
            this._progressBarMask.width = this._sumWidth;
            this._progressTxt.text = "100%";
            this._progressBar.visible = false;
            this._progressBg.visible = false;
            this._progressMc.visible = true;
            this._progressMc.play();
            PetsAdvancedManager.Instance.isAllMovieComplete = false;
            PetsAdvancedManager.Instance.frame.enableBtn = false;
            this.addEvent();
         }
         else
         {
            this._progressBarMask.width = Math.floor(this._currentExp / this._max * this._sumWidth * 100) / 100;
            this._progressTxt.text = Math.floor(this._currentExp / this._max * 10000) / 100 + "%";
         }
      }
      
      public function maxAdvancedGrade() : void
      {
         this.max = 0;
         this._progressBarMask.width = this._sumWidth;
         this._progressTxt.text = "100%";
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(this.numChildren)
         {
            ObjectUtils.disposeObject(this.getChildAt(0));
         }
         this._progressMc = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get max() : Number
      {
         return this._max;
      }
      
      public function set max(param1:Number) : void
      {
         this._max = param1;
      }
      
      public function get currentExp() : int
      {
         return this._currentExp;
      }
      
      public function set currentExp(param1:int) : void
      {
         this._currentExp = param1;
      }
   }
}
