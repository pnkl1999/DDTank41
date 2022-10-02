package game.view.smallMap
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.MissionInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.animations.DragMapAnimation;
   import game.model.LocalPlayer;
   import game.view.map.MapView;
   import phy.object.SmallObject;
   import room.RoomManager;
   
   public class SmallMapView extends Sprite implements Disposeable
   {
      
      private static const NUMBERS_ARR:Array = ["tank.game.smallmap.ShineNumber1","tank.game.smallmap.ShineNumber2","tank.game.smallmap.ShineNumber3","tank.game.smallmap.ShineNumber4","tank.game.smallmap.ShineNumber5","tank.game.smallmap.ShineNumber6","tank.game.smallmap.ShineNumber7","tank.game.smallmap.ShineNumber8","tank.game.smallmap.ShineNumber9"];
      
      public static var MAX_WIDTH:int = 165;
      
      public static var MIN_WIDTH:int = 120;
      
      public static const HARD_LEVEL:Array = [LanguageMgr.GetTranslation("tank.game.smallmap.simple"),LanguageMgr.GetTranslation("tank.game.smallmap.normal"),LanguageMgr.GetTranslation("tank.game.smallmap.difficulty"),LanguageMgr.GetTranslation("tank.game.smallmap.hero")];
      
      public static const HARD_LEVEL1:Array = [LanguageMgr.GetTranslation("tank.game.smallmap.simple1"),LanguageMgr.GetTranslation("tank.game.smallmap.normal1"),LanguageMgr.GetTranslation("tank.game.smallmap.difficulty1")];
       
      
      private var _screen:Sprite;
      
      private var _foreMap:Sprite;
      
      private var _thingLayer:Sprite;
      
      private var _mapBorder:Sprite;
      
      private var _hardTxt:FilterFrameText;
      
      private var _line:Sprite;
      
      private var _smallMapContainerBg:Sprite;
      
      private var _mask:Shape;
      
      private var _foreMapMask:Shape;
      
      private var _changeScale:Number = 0.2;
      
      private var _locked:Boolean;
      
      private var _allowDrag:Boolean = true;
      
      private var _split:Sprite;
      
      private var _texts:Array;
      
      private var _screenMask:Sprite;
      
      private var _processer:ThingProcesser;
      
      private var _drawMatrix:Matrix;
      
      private var _lineRef:BitmapData;
      
      private var _foreground:Shape;
      
      private var _dragScreen:Sprite;
      
      private var _titleBar:SmallMapTitleBar;
      
      private var _Screen_X:int;
      
      private var _Screen_Y:int;
      
      private var _mapBmp:Bitmap;
      
      private var _mapDeadBmp:Bitmap;
      
      private var _rateX:Number;
      
      private var _map:MapView;
      
      private var _rateY:Number;
      
      private var _missionInfo:MissionInfo;
      
      private var _w:int;
      
      private var _h:int;
      
      private var _groundShape:Sprite;
      
      private var _beadShape:Shape;
      
      private var _startDrag:Boolean = false;
      
      private var _child:Dictionary;
      
      private var _update:Boolean;
      
      public function SmallMapView(param1:MapView, param2:MissionInfo)
      {
         this._drawMatrix = new Matrix();
         this._child = new Dictionary();
         super();
         this._map = param1;
         this._missionInfo = param2;
         this._processer = new ThingProcesser();
         this.initView();
         this.initEvent();
      }
      
      public function set locked(param1:Boolean) : void
      {
         this._locked = param1;
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set allowDrag(param1:Boolean) : void
      {
         this._allowDrag = param1;
         if(!this._allowDrag)
         {
            this.__mouseUp(null);
         }
         this._screen.mouseChildren = this._screen.mouseEnabled = this._allowDrag;
      }
      
      public function get rateX() : Number
      {
         return this._rateX;
      }
      
      public function get rateY() : Number
      {
         return this._rateY;
      }
      
      public function get smallMapW() : Number
      {
         return this._mask.width;
      }
      
      public function get smallMapH() : Number
      {
         return this._mask.height;
      }
      
      public function setHardLevel(param1:int, param2:int = 0) : void
      {
         if(param2 == 0)
         {
            this._titleBar.title = HARD_LEVEL[param1];
         }
         else
         {
            this._titleBar.title = HARD_LEVEL1[param1];
         }
      }
      
      public function setBarrier(param1:int, param2:int) : void
      {
         this._titleBar.setBarrier(param1,param2);
      }
      
      private function initView() : void
      {
         this._drawMatrix.a = this._drawMatrix.d = 96 / this._map.bound.height;
         this._w = this._drawMatrix.a * this._map.bound.width;
         this._h = this._drawMatrix.d * this._map.bound.height;
         if(this._w > 240)
         {
            this._w = 240;
            this._drawMatrix.a = this._drawMatrix.d = 240 / this._map.bound.width;
            this._h = this._drawMatrix.d * this._map.bound.height;
         }
         this._groundShape = new Sprite();
         addChild(this._groundShape);
         this._beadShape = new Shape();
         addChild(this._beadShape);
         this._screen = new DragScreen(StageReferance.stageWidth * this._drawMatrix.a,StageReferance.stageHeight * this._drawMatrix.d);
         addChild(this._screen);
         this._thingLayer = new Sprite();
         this._thingLayer.mouseChildren = this._thingLayer.mouseEnabled = false;
         addChild(this._thingLayer);
         this._foreground = new Shape();
         addChild(this._foreground);
         this._titleBar = new SmallMapTitleBar(this._missionInfo);
         this._titleBar.width = this._w;
         this._titleBar.y = -this._titleBar.height + 1;
         y = this._titleBar.height;
         if(RoomManager.Instance.current.canShowTitle())
         {
            this._titleBar.title = HARD_LEVEL[RoomManager.Instance.current.hardLevel];
         }
         addChild(this._titleBar);
         this._lineRef = ComponentFactory.Instance.creatBitmapData("asset.game.lineAsset");
         this.drawBackground();
         this.drawForeground();
         this.updateSpliter();
      }
      
      public function get __StartDrag() : Boolean
      {
         return this._startDrag;
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(this._lineRef);
         _loc1_.drawRect(0,0,this._w,this._h);
         _loc1_.endFill();
         this._thingLayer.scrollRect = new Rectangle(0,0,this._w,this._h);
         _loc1_ = this._thingLayer.graphics;
         _loc1_.clear();
         _loc1_.beginFill(0,0);
         _loc1_.drawRect(0,0,this._w,this._h);
         _loc1_.endFill();
      }
      
      private function drawForeground() : void
      {
         var _loc1_:Graphics = this._foreground.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(1,6710886);
         _loc1_.beginFill(0,0);
         _loc1_.drawRect(0,0,this._w,this._h);
         _loc1_.endFill();
      }
      
      public function get foreMap() : Sprite
      {
         return this;
      }
      
      private function initViewAsset() : void
      {
      }
      
      private function updateSpliter() : void
      {
         var _loc3_:MovieClip = null;
         if(this._split == null)
         {
            return;
         }
         while(this._split.numChildren > 0)
         {
            this._split.removeChildAt(0);
         }
         this._texts = [];
         var _loc1_:Number = this._screen.width / 10;
         this._split.graphics.clear();
         this._split.graphics.lineStyle(1,16777215,1);
         var _loc2_:int = 1;
         while(_loc2_ < 10)
         {
            this._split.graphics.moveTo(_loc1_ * _loc2_,0);
            this._split.graphics.lineTo(_loc1_ * _loc2_,this._screen.height);
            _loc3_ = ClassUtils.CreatInstance(NUMBERS_ARR[_loc2_ - 1]);
            _loc3_.x = _loc1_ * _loc2_;
            _loc3_.y = (this._screen.height - _loc3_.height) / 2;
            _loc3_.stop();
            this._split.addChild(_loc3_);
            this._texts.push(_loc3_);
            _loc2_++;
         }
         this._split.graphics.endFill();
      }
      
      public function ShineText(param1:int) : void
      {
         this.large();
         this.drawMask();
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            setTimeout(this.shineText,_loc2_ * 1500,_loc2_);
            _loc2_++;
         }
      }
      
      private function drawMask() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Sprite = null;
         _loc1_ = null;
         _loc2_ = null;
         if(this._screenMask == null)
         {
            _loc1_ = getBounds(parent);
            this._screenMask = new Sprite();
            this._screenMask.graphics.beginFill(0,0.8);
            this._screenMask.graphics.drawRect(0,0,StageReferance.stageWidth,StageReferance.stageHeight);
            this._screenMask.graphics.endFill();
            this._screenMask.blendMode = BlendMode.LAYER;
            _loc2_ = new Sprite();
            _loc2_.graphics.beginFill(0,1);
            _loc2_.graphics.drawRect(0,0,_loc1_.width,_loc1_.height);
            _loc2_.graphics.endFill();
            _loc2_.x = this.x;
            _loc2_.y = _loc1_.top;
            _loc2_.blendMode = BlendMode.ERASE;
            this._screenMask.addChild(_loc2_);
         }
         LayerManager.Instance.addToLayer(this._screenMask,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      private function clearMask() : void
      {
         if(this._screenMask && this._screenMask.parent)
         {
            this._screenMask.parent.removeChild(this._screenMask);
         }
      }
      
      private function large() : void
      {
         scaleY = 3;
         scaleX = 3;
         x = StageReferance.stageWidth - width >> 1;
         y = StageReferance.stageHeight - height >> 1;
      }
      
      public function restore() : void
      {
         scaleY = 1;
         scaleX = 1;
         x = StageReferance.stageWidth - width - 1;
         y = this._titleBar.height;
         this.clearMask();
      }
      
      public function restoreText() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in this._texts)
         {
            _loc1_.gotoAndStop(1);
         }
      }
      
      private function shineText(param1:int) : void
      {
         this.restoreText();
         if(this._split == null)
         {
            this._split = new Sprite();
            this._split.mouseEnabled = false;
            this._split.mouseChildren = false;
            addChild(this._split);
            this.updateSpliter();
         }
         if(param1 > 4)
         {
            (this._texts[4] as MovieClip).play();
         }
         else
         {
            (this._texts[param1] as MovieClip).play();
         }
      }
      
      public function showSpliter() : void
      {
         if(this._split == null)
         {
            this._split = new Sprite();
            this._split.mouseEnabled = false;
            this._split.mouseChildren = false;
            addChild(this._split);
            this.updateSpliter();
         }
         this._split.visible = true;
      }
      
      public function hideSpliter() : void
      {
         if(this._split != null)
         {
            this._split.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         this._groundShape.addEventListener(MouseEvent.MOUSE_DOWN,this.__click);
         this._screen.addEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
      }
      
      private function removeEvents() : void
      {
         this._groundShape.removeEventListener(MouseEvent.MOUSE_DOWN,this.__click);
         this._screen.removeEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      private function __mouseDown(param1:MouseEvent) : void
      {
         this._Screen_X = this._screen.x;
         this._Screen_Y = this._screen.y;
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         var _loc2_:Rectangle = getBounds(this);
         _loc2_.top = 0;
         _loc2_.right -= this._screen.width;
         _loc2_.bottom -= this._screen.height;
         this._screen.startDrag(false,_loc2_);
         this._startDrag = true;
      }
      
      private function __mouseUp(param1:MouseEvent) : void
      {
         this._startDrag = false;
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         this._screen.stopDrag();
      }
      
      public function get screen() : Sprite
      {
         return this._screen;
      }
      
      public function get screenX() : int
      {
         return this._Screen_X;
      }
      
      public function get screenY() : int
      {
         return this._Screen_Y;
      }
      
      private function __mouseMove(param1:MouseEvent) : void
      {
      }
      
      private function __onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._startDrag)
         {
            _loc2_ = (this._screen.x + this._screen.width / 2) / this._drawMatrix.a;
            _loc3_ = (this._screen.y + this._screen.height / 2) / this._drawMatrix.d;
            this._map.animateSet.addAnimation(new DragMapAnimation(_loc2_,_loc3_,true));
            if(this._split)
            {
               this._split.x = this._screen.x;
               this._split.y = this._screen.y;
            }
         }
      }
      
      public function update() : void
      {
         this.draw(true);
         this.drawDead(true);
         this.updateSpliter();
         if(this._split != null)
         {
            this._split.x = this._screen.x;
            this._split.y = this._screen.y;
         }
      }
      
      private function drawDead(param1:Boolean = false) : void
      {
         if(!this._map.mapChanged && !param1)
         {
            return;
         }
         if(!this._map.stone)
         {
            return;
         }
         var _loc2_:Graphics = this._beadShape.graphics;
         _loc2_.clear();
         _loc2_.beginBitmapFill(this._map.stone.bitmapData,this._drawMatrix,false,true);
         _loc2_.drawRect(0,0,this._w,this._h);
         _loc2_.endFill();
      }
      
      public function draw(param1:Boolean = false) : void
      {
         if(!this._map.mapChanged && !param1)
         {
            return;
         }
         var _loc2_:Graphics = this._groundShape.graphics;
         _loc2_.clear();
         if(!this._map.ground)
         {
            _loc2_.beginFill(0,0);
         }
         else
         {
            _loc2_.beginBitmapFill(this._map.ground.bitmapData,this._drawMatrix,false,true);
         }
         _loc2_.drawRect(0,0,this._w,this._h);
         _loc2_.endFill();
      }
      
      public function setScreenPos(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Rectangle = null;
         if(!this._locked && !this._startDrag)
         {
            _loc3_ = Math.abs(param1 * this._drawMatrix.a);
            _loc4_ = Math.abs(param2 * this._drawMatrix.d);
            _loc5_ = this._screen.getBounds(this);
            if(_loc3_ + this._screen.width >= this._w)
            {
               this._screen.x = this._w - this._screen.width;
            }
            else if(_loc3_ < 0)
            {
               this._screen.x = 0;
            }
            else
            {
               this._screen.x = _loc3_;
            }
            if(_loc4_ + this._screen.height >= this._h)
            {
               this._screen.y = this._h - this._screen.height;
            }
            else if(_loc4_ < 0)
            {
               this._screen.y = 0;
            }
            else
            {
               this._screen.y = _loc4_;
            }
            if(this._split != null)
            {
               this._split.x = this._screen.x;
               this._split.y = this._screen.y;
            }
         }
      }
      
      public function addObj(param1:SmallObject) : void
      {
         if(!param1.onProcess)
         {
            this.addAnimation(param1);
         }
         this._thingLayer.addChild(param1);
      }
      
      public function removeObj(param1:SmallObject) : void
      {
         if(param1.parent == this._thingLayer)
         {
            this._thingLayer.removeChild(param1);
            if(param1.onProcess)
            {
               this.removeAnimation(param1);
            }
         }
      }
      
      public function updatePos(param1:SmallObject, param2:Point) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.x = param2.x * this._drawMatrix.a;
         param1.y = param2.y * this._drawMatrix.d;
         this._thingLayer.addChild(param1);
      }
      
      public function addAnimation(param1:SmallObject) : void
      {
         this._processer.addThing(param1);
      }
      
      public function removeAnimation(param1:SmallObject) : void
      {
         this._processer.removeThing(param1);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._missionInfo = null;
         if(this._titleBar)
         {
            ObjectUtils.disposeObject(this._titleBar);
            this._titleBar = null;
         }
         if(this._mapBmp)
         {
            if(this._mapBmp.parent)
            {
               this._mapBmp.parent.removeChild(this._mapBmp);
            }
            if(this._mapBmp.bitmapData)
            {
               this._mapBmp.bitmapData.dispose();
            }
         }
         this._mapBmp = null;
         if(this._mapDeadBmp)
         {
            if(this._mapDeadBmp.parent)
            {
               this._mapDeadBmp.parent.removeChild(this._mapDeadBmp);
            }
            if(this._mapDeadBmp.bitmapData)
            {
               this._mapDeadBmp.bitmapData.dispose();
            }
         }
         this._mapDeadBmp = null;
         if(this._line)
         {
            ObjectUtils.disposeAllChildren(this._line);
            if(this._line.parent)
            {
               this._line.parent.removeChild(this._line);
            }
            this._line = null;
         }
         if(this._screen)
         {
            ObjectUtils.disposeAllChildren(this._screen);
            if(this._screen.parent)
            {
               this._screen.parent.removeChild(this._screen);
            }
            this._screen = null;
         }
         if(this._smallMapContainerBg)
         {
            ObjectUtils.disposeAllChildren(this._smallMapContainerBg);
            if(this._smallMapContainerBg.parent)
            {
               this._smallMapContainerBg.parent.removeChild(this._smallMapContainerBg);
            }
            this._smallMapContainerBg = null;
         }
         if(this._split)
         {
            ObjectUtils.disposeAllChildren(this._split);
            if(this._split)
            {
               this._split.parent.removeChild(this._split);
            }
            this._split = null;
         }
         if(this._mapBorder)
         {
            ObjectUtils.disposeAllChildren(this._mapBorder);
            if(this._mapBorder.parent)
            {
               this._mapBorder.parent.removeChild(this._mapBorder);
            }
            this._mapBorder = null;
         }
         if(this._map.parent)
         {
            this._map.parent.removeChild(this._map);
         }
         this._map = null;
         ObjectUtils.disposeAllChildren(this);
         if(this._lineRef)
         {
            this._lineRef.dispose();
            this._lineRef = null;
         }
         this._processer.dispose();
         this._processer = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function __largeMap(param1:MouseEvent) : void
      {
         this._changeScale = 0.2;
         var _loc2_:Number = this._rateX;
         var _loc3_:Number = this._rateY;
         this.update();
         this.updateChildPos(_loc2_,_loc3_);
         SoundManager.instance.play("008");
      }
      
      private function __smallMap(param1:MouseEvent) : void
      {
         this._changeScale = -0.2;
         var _loc2_:Number = this._rateX;
         var _loc3_:Number = this._rateY;
         this.update();
         this.updateChildPos(_loc2_,_loc3_);
         SoundManager.instance.play("008");
      }
      
      private function updateChildPos(param1:Number, param2:Number) : void
      {
         var _loc3_:Sprite = null;
         for each(_loc3_ in this._child)
         {
            _loc3_.x = _loc3_.x / param1 * this._rateX;
            _loc3_.y = _loc3_.y / param2 * this._rateY;
         }
      }
      
      private function __click(param1:MouseEvent) : void
      {
         if(!this._locked && this._allowDrag)
         {
            this._map.animateSet.addAnimation(new DragMapAnimation(param1.localX / this._drawMatrix.a,param1.localY / this._drawMatrix.d));
         }
      }
      
      private function __enterFrame(param1:Event) : void
      {
         var _loc2_:Number = (this._screen.x + this._screen.width / 2) / this._rateX;
         var _loc3_:Number = (this._screen.y + this._screen.height / 2) / this._rateY;
         if(this._split != null)
         {
            this._split.x = this._screen.x;
            this._split.y = this._screen.y;
         }
         this._map.animateSet.addAnimation(new DragMapAnimation(_loc2_,_loc3_,true));
      }
      
      public function moveToPlayer() : void
      {
         var _loc1_:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
         var _loc2_:Number = _loc1_.pos.x;
         var _loc3_:Number = (this._screen.y + this._screen.height / 2) / this._drawMatrix.d;
         this._map.animateSet.addAnimation(new DragMapAnimation(_loc2_,_loc3_,true));
      }
      
      public function get titleBar() : SmallMapTitleBar
      {
         return this._titleBar;
      }
      
      public function set enableExit(param1:Boolean) : void
      {
         this._titleBar.enableExit = param1;
      }
   }
}

import com.pickgliss.toplevel.StageReferance;
import flash.events.Event;
import flash.utils.getTimer;
import phy.object.SmallObject;

class ThingProcesser
{
    
   
   private var _objectList:Vector.<SmallObject>;
   
   private var _startuped:Boolean = false;
   
   private var _lastTime:int = 0;
   
   function ThingProcesser()
   {
      this._objectList = new Vector.<SmallObject>();
      super();
   }
   
   public function addThing(param1:SmallObject) : void
   {
      if(!param1.onProcess)
      {
         this._objectList.push(param1);
         param1.onProcess = true;
         this.startup();
      }
   }
   
   public function removeThing(param1:SmallObject) : void
   {
      if(!param1.onProcess)
      {
         return;
      }
      var _loc2_:int = this._objectList.length;
      var _loc3_:int = 0;
      while(_loc3_ < _loc2_)
      {
         if(this._objectList[_loc3_] == param1)
         {
            this._objectList.splice(_loc3_,1);
            param1.onProcess = false;
            if(this._objectList.length <= 0)
            {
               this.shutdown();
            }
            return;
         }
         _loc3_++;
      }
   }
   
   public function startup() : void
   {
      if(!this._startuped)
      {
         this._lastTime = getTimer();
         StageReferance.stage.addEventListener(Event.ENTER_FRAME,this.__onFrame);
         this._startuped = true;
      }
   }
   
   private function __onFrame(param1:Event) : void
   {
      var _loc5_:SmallObject = null;
      var _loc2_:int = getTimer();
      var _loc3_:int = _loc2_ - this._lastTime;
      var _loc4_:int = getTimer();
      for each(_loc5_ in this._objectList)
      {
         _loc5_.onFrame(_loc3_);
      }
      this._lastTime = _loc2_;
   }
   
   public function shutdown() : void
   {
      if(this._startuped)
      {
         this._lastTime = 0;
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.__onFrame);
         this._startuped = false;
      }
   }
   
   public function dispose() : void
   {
      this.shutdown();
      var _loc1_:SmallObject = this._objectList.shift();
      while(_loc1_ != null)
      {
         _loc1_.onProcess = false;
         _loc1_ = this._objectList.shift();
      }
      this._objectList = null;
   }
}
