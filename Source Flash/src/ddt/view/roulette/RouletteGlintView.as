package ddt.view.roulette
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class RouletteGlintView extends Sprite implements Disposeable
   {
      
      public static const BIGGLINTCOMPLETE:String = "bigGlintComplete";
       
      
      private var _timer:Timer;
      
      private var _glintType:int = 0;
      
      private var _pointArray:Array;
      
      private var _bigGlintSprite:MovieClip;
      
      private var _glintArray:Vector.<MovieClip>;
      
      public function RouletteGlintView(param1:Array)
      {
         super();
         this.init();
         this.initEvent();
         this._pointArray = param1;
      }
      
      private function init() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this._timer = new Timer(100,1);
         this._timer.stop();
         this._glintArray = new Vector.<MovieClip>();
      }
      
      private function initEvent() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
      }
      
      private function _timerComplete(param1:TimerEvent) : void
      {
         this._timer.stop();
         this._clearGlint();
      }
      
      private function _restartTimer(param1:int) : void
      {
         this._timer.delay = param1;
         this._timer.reset();
         this._timer.start();
      }
      
      public function showOneCell(param1:int, param2:int) : void
      {
         var _loc3_:MovieClip = null;
         this.glintType = 1;
         if(param1 >= 0 && param1 <= 17)
         {
            _loc3_ = ComponentFactory.Instance.creat("asset.awardSystem.roulette.GlintAsset");
            _loc3_.x = this._pointArray[param1].x;
            _loc3_.y = this._pointArray[param1].y;
            addChild(_loc3_);
            this._glintArray.push(_loc3_);
            this._restartTimer(param2);
         }
      }
      
      public function showTwoStep(param1:int) : void
      {
         this.glintType = 2;
         this.showAllCell();
         this.showBigGlint();
         this._restartTimer(param1);
      }
      
      public function showAllCell() : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = null;
         var _loc1_:int = 0;
         while(_loc1_ <= 17)
         {
            _loc2_ = ComponentFactory.Instance.creat("asset.awardSystem.roulette.GlintAsset");
            _loc2_.x = this._pointArray[_loc1_].x;
            _loc2_.y = this._pointArray[_loc1_].y;
            addChild(_loc2_);
            this._glintArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function showBigGlint() : void
      {
         this._bigGlintSprite = ComponentFactory.Instance.creat("asset.awardSystem.roulette.BigGlintAsset");
         addChild(this._bigGlintSprite);
      }
      
      private function _clearGlint() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._glintArray.length)
         {
            _loc2_ = this._glintArray[_loc1_] as MovieClip;
            removeChild(_loc2_);
            _loc1_++;
         }
         if(this._bigGlintSprite)
         {
            removeChild(this._bigGlintSprite);
            this._bigGlintSprite = null;
         }
         this._glintArray.splice(0,this._glintArray.length);
         if(this.glintType == 2)
         {
            dispatchEvent(new Event(BIGGLINTCOMPLETE));
         }
      }
      
      public function set glintType(param1:int) : void
      {
         this._glintType = param1;
      }
      
      public function get glintType() : int
      {
         return this._glintType;
      }
      
      public function dispose() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer = null;
         }
         if(this._bigGlintSprite)
         {
            ObjectUtils.disposeObject(this._bigGlintSprite);
         }
         this._bigGlintSprite = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._glintArray.length)
         {
            ObjectUtils.disposeObject(this._glintArray[_loc1_]);
            _loc1_++;
         }
         this._glintArray.splice(0,this._glintArray.length);
      }
   }
}
