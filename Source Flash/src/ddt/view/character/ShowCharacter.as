package ddt.view.character
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ShowCharacter extends BaseCharacter
   {
      
      public static const STAND:String = "stand";
      
      public static const WIN:String = "win";
      
      public static const LOST:String = "lost";
      
      public static const BIG_WIDTH:int = 250;
      
      public static const BIG_HEIGHT:int = 342;
       
      
      private var _showLight:Boolean;
      
      private var _lightPos:Point;
      
      private var _light1:MovieClip;
      
      private var _light2:MovieClip;
      
      private var _light01:BaseLightLayer;
      
      private var _light02:SinpleLightLayer;
      
      private var _loading:MovieClip;
      
      private var _showGun:Boolean;
      
      private var _characterWithWeapon:BitmapData;
      
      private var _characterWithoutWeapon:BitmapData;
      
      private var _wing:MovieClip;
      
      private var _staticBmp:Sprite;
      
      private var _currentAction:String;
      
      private var _recordNimbus:int;
      
      private var _needMultiFrame:Boolean;
      
      private var _playAnimation:Boolean = true;
      
      private var _wpCrtBmd:BitmapData;
      
      private var _winCrtBmd:BitmapData;
      
      public function ShowCharacter(param1:PlayerInfo, param2:Boolean = true, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,false);
         this._showGun = param2;
         this._showLight = param3;
         this._lightPos = new Point(0,0);
         this._needMultiFrame = param4;
         this._loading = ComponentFactory.Instance.creat("asset.core.character.FigureBgAsset") as MovieClip;
         _container.addChild(this._loading);
         this._currentAction = STAND;
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         _info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChangeII);
      }
      
      private function __propertyChangeII(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerInfo.NIMBUS])
         {
            this.updateLight();
         }
      }
      
      override public function set showGun(param1:Boolean) : void
      {
         if(param1 == this._showGun)
         {
            return;
         }
         this._showGun = param1;
         this.updateCharacter();
      }
      
      override protected function initLoader() : void
      {
         _loader = _factory.createLoader(_info,CharacterLoaderFactory.SHOW);
         ShowCharacterLoader(_loader).needMultiFrames = this._needMultiFrame;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = _dir = param1;
         if(!_loadCompleted)
         {
            this._loading.loading1.visible = param1 == 1;
            this._loading.loading2.visible = !this._loading.loading1.visible;
         }
         _container.x = param1 < 0 ? Number(Number(-_characterWidth)) : Number(Number(0));
      }
      
      override public function setShowLight(param1:Boolean, param2:Point = null) : void
      {
         if(this._showLight == param1 && this._lightPos == param2)
         {
            return;
         }
         this._showLight = param1;
         if(param1)
         {
            if(param2 == null)
            {
               param2 = new Point(0,0);
            }
            this._lightPos = param2;
         }
         this.updateLight();
      }
      
      private function stopMovieClip(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            param1.gotoAndStop(1);
            if(param1.numChildren > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < param1.numChildren)
               {
                  this.stopMovieClip(param1.getChildAt(_loc2_) as MovieClip);
                  _loc2_++;
               }
            }
         }
      }
      
      private function playMovieClip(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            param1.gotoAndPlay(1);
            if(param1.numChildren > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < param1.numChildren)
               {
                  this.playMovieClip(param1.getChildAt(_loc2_) as MovieClip);
                  _loc2_++;
               }
            }
         }
      }
      
      private function stopWing() : void
      {
         this.stopMovieClip(this._wing);
      }
      
      public function stopAnimation() : void
      {
         this._playAnimation = false;
         this.stopAllMoiveClip();
      }
      
      public function playAnimation() : void
      {
         this._playAnimation = true;
         this.playAllMoiveClip();
      }
      
      private function stopAllMoiveClip() : void
      {
         this.stopMovieClip(this._light1);
         this.stopMovieClip(this._light2);
         this.stopWing();
      }
      
      private function playAllMoiveClip() : void
      {
         this.playMovieClip(this._light1);
         this.playMovieClip(this._light2);
         this.playMovieClip(this._wing);
      }
      
      private function restoreAnimationState() : void
      {
         if(this._playAnimation)
         {
            this.playAllMoiveClip();
         }
         else
         {
            this.stopAllMoiveClip();
         }
      }
      
      private function drawBitmapWithWingAndLight() : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc3_ = null;
         _loc4_ = 0;
         var _loc6_:Sprite = null;
         if(_container == null || !_loadCompleted)
         {
            return;
         }
         this.stopAllMoiveClip();
         _loc1_ = _container.x;
         _loc2_ = _container.y;
         _loc3_ = _container.parent;
         _loc4_ = _loc3_.getChildIndex(_container);
         var _loc5_:Rectangle = _container.getBounds(_container);
         _loc6_ = new Sprite();
         _loc3_.removeChild(_container);
         _container.x = -_loc5_.x * _container.scaleX;
         _container.y = -_loc5_.y * _container.scaleX;
         _loc6_.addChild(_container);
         var _loc7_:BitmapData = new BitmapData(_loc6_.width,_loc6_.height,true,0);
         _loc7_.draw(_loc6_);
         var _loc8_:Bitmap = new Bitmap(_loc7_,"auto",true);
         _loc6_.removeChild(_container);
         _loc6_.addChild(_loc8_);
         _container.x = _loc1_;
         _container.y = _loc2_;
         _loc3_.addChildAt(_container,_loc4_);
         if(_loc6_.width > 140)
         {
            _loc6_.x = _loc6_.width - 17;
         }
         else
         {
            _loc6_.x = _loc6_.width;
         }
         this._staticBmp = _loc6_;
         this.restoreAnimationState();
      }
      
      public function getShowBitmapBig() : DisplayObject
      {
         if(this._staticBmp == null)
         {
            this.drawBitmapWithWingAndLight();
         }
         return this._staticBmp;
      }
      
      public function resetShowBitmapBig() : void
      {
         if(this._staticBmp && this._staticBmp.parent)
         {
            this._staticBmp.parent.removeChild(this._staticBmp);
         }
         this._staticBmp = null;
      }
      
      private function updateLight() : void
      {
         if(_info == null)
         {
            return;
         }
         if(this._showLight && this.currentAction == STAND)
         {
            if(this._recordNimbus != _info.Nimbus)
            {
               this._recordNimbus = _info.Nimbus;
               if(_info.getHaveLight())
               {
                  if(this._light02)
                  {
                     this._light02.dispose();
                  }
                  this._light02 = new SinpleLightLayer(_info.Nimbus);
                  this._light02.load(this.callBack02);
               }
               else
               {
                  if(this._light02)
                  {
                     this._light02.dispose();
                  }
                  if(this._light2 && this._light2.parent)
                  {
                     this._light2.parent.removeChild(this._light2);
                  }
                  this._light2 = null;
               }
               if(_info.getHaveCircle())
               {
                  if(this._light01)
                  {
                     this._light01.dispose();
                  }
                  this._light01 = new BaseLightLayer(_info.Nimbus);
                  this._light01.load(this.callBack01);
               }
               else
               {
                  if(this._light01)
                  {
                     this._light01.dispose();
                  }
                  if(this._light1 && this._light1.parent)
                  {
                     this._light1.parent.removeChild(this._light1);
                  }
                  this._light1 = null;
               }
            }
         }
         else
         {
            this._recordNimbus = 0;
            if(this._light01)
            {
               this._light01.dispose();
            }
            if(this._light02)
            {
               this._light02.dispose();
            }
            if(this._light1 && this._light1.parent)
            {
               this._light1.parent.removeChild(this._light1);
            }
            if(this._light2 && this._light2.parent)
            {
               this._light2.parent.removeChild(this._light2);
            }
            this._light1 = null;
            this._light2 = null;
         }
      }
      
      private function callBack01(param1:BaseLightLayer) : void
      {
         if(this._light1 && this._light1.parent)
         {
            this._light1.parent.removeChild(this._light1);
         }
         this._light1 = param1.getContent() as MovieClip;
         if(this._light1 != null)
         {
            _container.addChildAt(this._light1,0);
            this._light1.x = this._lightPos.x + 47;
            this._light1.y = this._lightPos.y + 65;
         }
         this.drawBitmapWithWingAndLight();
         this.restoreAnimationState();
      }
      
      private function callBack02(param1:SinpleLightLayer) : void
      {
         if(this._light2 && this._light2.parent)
         {
            this._light2.parent.removeChild(this._light2);
         }
         this._light2 = param1.getContent() as MovieClip;
         if(this._light2 != null)
         {
            _container.addChild(this._light2);
            this._light2.x = this._lightPos.x + 45;
            this._light2.y = this._lightPos.y + 126;
         }
         this.drawBitmapWithWingAndLight();
         this.restoreAnimationState();
      }
      
      private function updateCharacter() : void
      {
         if(_loader != null && _loader.getContent()[0] != null)
         {
            this.__loadComplete(_loader);
         }
         else
         {
            this.setContent();
         }
      }
      
      public function get characterWithWeapon() : BitmapData
      {
         return this._characterWithWeapon;
      }
      
      override protected function setContent() : void
      {
         var _loc1_:Array = null;
         if(_loader != null)
         {
            _loc1_ = _loader.getContent();
            if(this._characterWithWeapon && this._characterWithWeapon != _loc1_[0])
            {
               this._characterWithWeapon.dispose();
            }
            if(this._characterWithoutWeapon && this._characterWithoutWeapon != _loc1_[1])
            {
               this._characterWithoutWeapon.dispose();
            }
            this._characterWithWeapon = _loc1_[0];
            this._characterWithoutWeapon = _loc1_[1];
            if(this._wpCrtBmd)
            {
               this._wpCrtBmd.dispose();
            }
            this._wpCrtBmd = null;
            if(this._winCrtBmd)
            {
               this._winCrtBmd.dispose();
            }
            this._winCrtBmd = null;
            if(this._wing && this._wing.parent)
            {
               this._wing.parent.removeChild(this._wing);
            }
            this._wing = _loc1_[2];
         }
         if(this._showGun)
         {
            characterBitmapdata = this._characterWithWeapon;
         }
         else
         {
            characterBitmapdata = this._characterWithoutWeapon;
         }
         this.doAction(this._currentAction);
         this.drawBitmapWithWingAndLight();
      }
      
      public function get charaterWithoutWeapon() : BitmapData
      {
         if(this._wpCrtBmd == null)
         {
            this._wpCrtBmd = new BitmapData(_characterWidth,_characterHeight,true,0);
            this._wpCrtBmd.copyPixels(this._characterWithoutWeapon,_frames[0],new Point(0,0));
         }
         return this._wpCrtBmd;
      }
      
      public function get winCharater() : BitmapData
      {
         if(this._winCrtBmd == null)
         {
            this._winCrtBmd = new BitmapData(_characterWidth,_characterHeight,true,0);
            this._winCrtBmd.copyPixels(_characterBitmapdata,_frames[1],new Point(0,0));
         }
         return this._winCrtBmd;
      }
      
      private function updateWing() : void
      {
         if(this._wing == null)
         {
            return;
         }
         var _loc1_:int = _container.getChildIndex(_body);
         _loc1_ = _loc1_ < 1 ? int(int(0)) : int(int(_loc1_ - 1));
         var _loc2_:Array = _info.Style.split(",");
         var _loc3_:Boolean = ItemManager.Instance.getTemplateById(int(_loc2_[8].split("|")[0])).Property1 != "1";
         if(_info.getSuitsType() == 1 && _loc3_)
         {
            this._wing.y = -40;
         }
         else
         {
            this._wing.y = 2;
            this._wing.x = -1;
         }
         if(_info.wingHide)
         {
            if(this._wing.parent != null)
            {
               this._wing.parent.removeChild(this._wing);
            }
         }
         else
         {
            _container.addChild(this._wing);
         }
         this.sortIndex();
      }
      
      private function sortIndex() : void
      {
         if(this._light1 != null)
         {
            _container.addChild(this._light1);
         }
         if(this._wing != null && !_info.wingHide)
         {
            _container.addChild(this._wing);
         }
         if(_body != null)
         {
            _container.addChild(_body);
         }
         if(this._light2 != null)
         {
            _container.addChild(this._light2);
         }
      }
      
      public function removeWing() : void
      {
         if(this._wing && this._wing.parent)
         {
            this._wing.parent.removeChild(this._wing);
         }
      }
      
      override protected function __loadComplete(param1:ICharacterLoader) : void
      {
         if(this._loading != null)
         {
            if(this._loading.parent)
            {
               this._loading.parent.removeChild(this._loading);
            }
         }
         super.__loadComplete(param1);
         this.updateLight();
      }
      
      override public function doAction(param1:*) : void
      {
         this._currentAction = param1;
         if(_info.getSuitsType() == 1)
         {
            _body.y = -13;
         }
         else
         {
            _body.y = 0;
         }
         switch(this._currentAction)
         {
            case ShowCharacter.STAND:
               drawFrame(0);
               this.updateWing();
               break;
            case ShowCharacter.WIN:
               drawFrame(1);
               this.removeWing();
               break;
            case ShowCharacter.LOST:
               drawFrame(2);
               this.removeWing();
         }
      }
      
      override protected function initSizeAndPics() : void
      {
         setCharacterSize(BIG_WIDTH,BIG_HEIGHT);
         setPicNum(1,2);
      }
      
      override public function show(param1:Boolean = true, param2:int = 1, param3:Boolean = true) : void
      {
         super.show(param1,param2,param3);
         if(param3)
         {
            _body.width = BaseCharacter.BASE_WIDTH;
            _body.height = BaseCharacter.BASE_HEIGHT;
            _body.cacheAsBitmap = true;
         }
         else
         {
            _body.width = BIG_WIDTH;
            _body.height = BIG_HEIGHT;
            _body.cacheAsBitmap = false;
         }
      }
      
      override public function get currentAction() : *
      {
         return this._currentAction;
      }
      
      override public function dispose() : void
      {
         if(_info)
         {
            _info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChangeII);
         }
         if(this._light01)
         {
            this._light01.dispose();
         }
         this._light01 = null;
         if(this._light02)
         {
            this._light02.dispose();
         }
         this._light02 = null;
         if(this._light2 && this._light2.parent)
         {
            this._light2.parent.removeChild(this._light2);
         }
         this._light2 = null;
         if(this._light1 && this._light1.parent)
         {
            this._light1.parent.removeChild(this._light1);
         }
         this._light1 = null;
         super.dispose();
         if(this._characterWithoutWeapon)
         {
            this._characterWithoutWeapon.dispose();
         }
         this._characterWithoutWeapon = null;
         if(this._staticBmp)
         {
            ObjectUtils.disposeAllChildren(this._staticBmp);
            ObjectUtils.disposeObject(this._staticBmp);
            this._staticBmp = null;
         }
         if(this._characterWithWeapon)
         {
            this._characterWithWeapon.dispose();
         }
         this._characterWithWeapon = null;
         if(this._wing && this._wing.parent)
         {
            this._wing.parent.removeChild(this._wing);
         }
         this._wing = null;
         if(this._winCrtBmd)
         {
            this._winCrtBmd.dispose();
         }
         this._winCrtBmd = null;
         if(this._wpCrtBmd)
         {
            this._wpCrtBmd.dispose();
         }
         this._wpCrtBmd = null;
         if(this._loading && this._loading.parent)
         {
            this._loading.parent.removeChild(this._loading);
         }
         this._loading = null;
         this._lightPos = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
