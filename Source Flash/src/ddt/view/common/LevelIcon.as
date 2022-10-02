package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.LevelTipInfo;
   import flash.display.Bitmap;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import road7th.utils.MathUtils;
   import trainer.controller.LevelRewardManager;
   
   public class LevelIcon extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static const MAX_LEVEL:int = 60;
      
      public static const MIN_LEVEL:int = 1;
      
      public static const SIZE_BIG:int = 0;
      
      public static const SIZE_SMALL:int = 1;
      
      private static const LEVEL_EFFECT_CLASSPATH:String = "asset.LevelIcon.LevelEffect_";
      
      private static const LEVEL_ICON_CLASSPATH:String = "asset.LevelIcon.Level_";
       
      
      private var _isBitmap:Boolean;
      
      private var _level:int;
      
      private var _levelBitmaps:Dictionary;
      
      private var _levelEffects:Dictionary;
      
      private var _levelTipInfo:LevelTipInfo;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _size:int;
      
      private var _bmContainer:Sprite;
      
      public function LevelIcon()
      {
         super();
         this._levelBitmaps = new Dictionary();
         this._levelEffects = new Dictionary();
         this._levelTipInfo = new LevelTipInfo();
         this._tipStyle = "core.LevelTips";
         this._tipGapV = 5;
         this._tipGapH = 5;
         this._tipDirctions = "7,6,5";
         this._size = SIZE_BIG;
         mouseChildren = true;
         mouseEnabled = false;
         this._bmContainer = new Sprite();
         this._bmContainer.buttonMode = true;
         addChild(this._bmContainer);
         ShowTipManager.Instance.addTip(this);
      }
      
      private function __click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LevelRewardManager.Instance.showFrame(PlayerManager.Instance.Self.Grade);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         var _loc2_:Bitmap = null;
         this._bmContainer.removeEventListener(MouseEvent.CLICK,this.__click);
         ShowTipManager.Instance.removeTip(this);
         this.clearnDisplay();
         for(_loc1_ in this._levelBitmaps)
         {
            _loc2_ = this._levelBitmaps[_loc1_];
            _loc2_.bitmapData.dispose();
            delete this._levelBitmaps[_loc1_];
         }
         this._levelBitmaps = null;
         this._levelEffects = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function setInfo(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:Boolean = true, param8:Boolean = true, param9:int = 1) : void
      {
         var _loc10_:Boolean = this._level != param1;
         this._level = MathUtils.getValueInRange(param1,MIN_LEVEL,MAX_LEVEL);
         this._isBitmap = param8;
         this._levelTipInfo.Level = this._level;
         this._levelTipInfo.Battle = param5;
         this._levelTipInfo.Win = param3;
         this._levelTipInfo.Repute = param2;
         this._levelTipInfo.Total = param4;
         this._levelTipInfo.exploit = param6;
         this._levelTipInfo.enableTip = param7;
         this._levelTipInfo.team = param9;
         if(_loc10_)
         {
            this.updateView();
         }
      }
      
      public function setSize(param1:int) : void
      {
         this._size = param1;
         this.updateSize();
      }
      
      public function get tipData() : Object
      {
         return this._levelTipInfo;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._levelTipInfo = param1 as LevelTipInfo;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function allowClick() : void
      {
         this._bmContainer.addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      private function addCurrentLevelBitmap() : void
      {
         addChild(this._bmContainer);
         this._bmContainer.addChild(this.creatLevelBitmap(this._level));
      }
      
      private function addCurrentLevelEffect() : void
      {
         var _loc1_:MovieClip = null;
         if(this._isBitmap)
         {
            return;
         }
         _loc1_ = this.creatLevelEffect(this._level);
         if(_loc1_)
         {
            _loc1_.mouseEnabled = false;
            _loc1_.mouseChildren = false;
            _loc1_.play();
            if(this._level > 40)
            {
               _loc1_.blendMode = BlendMode.ADD;
            }
            addChild(_loc1_);
         }
      }
      
      private function clearnDisplay() : void
      {
         var _loc1_:MovieClip = null;
         while(this._bmContainer.numChildren > 0)
         {
            this._bmContainer.removeChildAt(0);
         }
         while(numChildren > 0)
         {
            _loc1_ = getChildAt(0) as MovieClip;
            if(_loc1_)
            {
               _loc1_.stop();
            }
            removeChildAt(0);
         }
      }
      
      private function creatLevelBitmap(param1:int) : Bitmap
      {
         if(this._levelBitmaps[param1])
         {
            return this._levelBitmaps[param1];
         }
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap(LEVEL_ICON_CLASSPATH + param1.toString());
         _loc2_.smoothing = true;
         this._levelBitmaps[param1] = _loc2_;
         return _loc2_;
      }
      
      private function creatLevelEffect(param1:int) : MovieClip
      {
         var _loc2_:int = 0;
         if(MathUtils.isInRange(param1,10,20))
         {
            _loc2_ = 1;
         }
         if(MathUtils.isInRange(param1,20,30))
         {
            _loc2_ = 2;
         }
         if(MathUtils.isInRange(param1,30,40))
         {
            _loc2_ = 3;
         }
         if(MathUtils.isInRange(param1,40,50))
         {
            _loc2_ = 4;
         }
         if(MathUtils.isInRange(param1,50,60))
         {
            _loc2_ = 5;
         }
         if(_loc2_ == 0)
         {
            return null;
         }
         if(this._levelEffects[_loc2_])
         {
            return this._levelEffects[_loc2_];
         }
         var _loc3_:MovieClip = ComponentFactory.Instance.creat(LEVEL_EFFECT_CLASSPATH + _loc2_.toString());
         _loc3_.stop();
         this._levelEffects[_loc2_] = _loc3_;
         return _loc3_;
      }
      
      private function updateView() : void
      {
         this.clearnDisplay();
         this.addCurrentLevelBitmap();
         this.addCurrentLevelEffect();
         this.updateSize();
      }
      
      private function updateSize() : void
      {
         if(this._size == SIZE_SMALL)
         {
            scaleX = scaleY = 0.6;
         }
         else if(this._size == SIZE_BIG)
         {
            scaleX = scaleY = 0.75;
         }
      }
   }
}
