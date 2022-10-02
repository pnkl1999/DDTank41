package hotSpring.player
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.MovieImage;
   import ddt.data.player.PlayerInfo;
   import ddt.view.sceneCharacter.SceneCharacterActionItem;
   import ddt.view.sceneCharacter.SceneCharacterActionSet;
   import ddt.view.sceneCharacter.SceneCharacterItem;
   import ddt.view.sceneCharacter.SceneCharacterLoaderBody;
   import ddt.view.sceneCharacter.SceneCharacterLoaderHead;
   import ddt.view.sceneCharacter.SceneCharacterPlayerBase;
   import ddt.view.sceneCharacter.SceneCharacterSet;
   import ddt.view.sceneCharacter.SceneCharacterStateItem;
   import ddt.view.sceneCharacter.SceneCharacterStateSet;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HotSpringPlayerBase extends SceneCharacterPlayerBase
   {
       
      
      private var _playerInfo:PlayerInfo;
      
      private var _sceneCharacterStateSet:SceneCharacterStateSet;
      
      private var _sceneCharacterSetNatural:SceneCharacterSet;
      
      private var _sceneCharacterSetWater:SceneCharacterSet;
      
      private var _sceneCharacterLoaderPath:String;
      
      private var _sceneCharacterActionSetNatural:SceneCharacterActionSet;
      
      private var _sceneCharacterActionSetWater:SceneCharacterActionSet;
      
      private var _sceneCharacterLoaderHead:SceneCharacterLoaderHead;
      
      private var _sceneCharacterLoaderBody:SceneCharacterLoaderBody;
      
      private var _headBitmapData:BitmapData;
      
      private var _bodyBitmapData:BitmapData;
      
      private var _rectangle:Rectangle;
      
      private var _headMaskAsset:MovieImage;
      
      public var playerWitdh:Number = 120;
      
      public var playerHeight:Number = 175;
      
      private var _callBack:Function;
      
      public function HotSpringPlayerBase(param1:PlayerInfo, param2:Function = null)
      {
         this._rectangle = new Rectangle();
         super(param2);
         this._playerInfo = param1;
         this._callBack = param2;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._sceneCharacterStateSet = new SceneCharacterStateSet();
         this._sceneCharacterActionSetNatural = new SceneCharacterActionSet();
         this._sceneCharacterActionSetWater = new SceneCharacterActionSet();
         this.sceneCharacterLoadHead();
      }
      
      private function sceneCharacterLoadHead() : void
      {
         this._sceneCharacterLoaderHead = new SceneCharacterLoaderHead(this._playerInfo);
         this._sceneCharacterLoaderHead.load(this.sceneCharacterLoaderHeadCallBack);
      }
      
      private function sceneCharacterLoaderHeadCallBack(param1:SceneCharacterLoaderHead, param2:Boolean = true) : void
      {
         this._headBitmapData = param1.getContent()[0] as BitmapData;
         if(param1)
         {
            param1.dispose();
         }
         param1 = null;
         if(!param2 || !this._headBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false);
            }
            return;
         }
         this.sceneCharacterStateNatural();
      }
      
      private function sceneCharacterStateNatural() : void
      {
         var _loc1_:BitmapData = null;
         this._sceneCharacterSetNatural = new SceneCharacterSet();
         var _loc2_:Vector.<Point> = new Vector.<Point>();
         _loc2_.push(new Point(0,0));
         _loc2_.push(new Point(0,0));
         _loc2_.push(new Point(0,-1));
         _loc2_.push(new Point(0,2));
         _loc2_.push(new Point(0,0));
         _loc2_.push(new Point(0,-1));
         _loc2_.push(new Point(0,2));
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontHead","NaturalFrontAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,1,_loc2_,true,7));
         this._rectangle.x = this.playerWitdh;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseHead","NaturalFrontEyesCloseAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,2));
         this._rectangle.x = this.playerWitdh * 2;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight * 2,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackHead","NaturalBackAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,6,_loc2_,true,7));
         this.sceneCharacterLoadBodyNatural();
      }
      
      private function sceneCharacterLoadBodyNatural() : void
      {
         if(this._playerInfo.IsVIP)
         {
            this._sceneCharacterLoaderPath = "cloth4";
         }
         else
         {
            this._sceneCharacterLoaderPath = "cloth2";
         }
         this._sceneCharacterLoaderBody = new SceneCharacterLoaderBody(this._playerInfo,this._sceneCharacterLoaderPath);
         this._sceneCharacterLoaderBody.load(this.sceneCharacterLoaderBodyNaturalCallBack);
      }
      
      private function sceneCharacterLoaderBodyNaturalCallBack(param1:SceneCharacterLoaderBody, param2:Boolean = true) : void
      {
         var _loc3_:BitmapData = null;
         this._bodyBitmapData = param1.getContent()[0] as BitmapData;
         this._sceneCharacterLoaderPath = null;
         if(param1)
         {
            param1.dispose();
         }
         param1 = null;
         if(!param2 || !this._bodyBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false);
            }
            return;
         }
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this._bodyBitmapData.width;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontBody","NaturalFrontAction",_loc3_,1,7,this.playerWitdh,this.playerHeight,3));
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseBody","NaturalFrontEyesCloseAction",_loc3_,1,1,this.playerWitdh,this.playerHeight,4));
         this._rectangle.x = 0;
         this._rectangle.y = this.playerHeight;
         this._rectangle.width = this._bodyBitmapData.width;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackBody","NaturalBackAction",_loc3_,1,7,this.playerWitdh,this.playerHeight,5));
         var _loc4_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandFront",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7],true);
         this._sceneCharacterActionSetNatural.push(_loc4_);
         var _loc5_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandBack",[8],false);
         this._sceneCharacterActionSetNatural.push(_loc5_);
         var _loc6_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkFront",[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6],true);
         this._sceneCharacterActionSetNatural.push(_loc6_);
         var _loc7_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkBack",[9,9,9,10,10,10,11,11,11,12,12,12,13,13,13,14,14,14],true);
         this._sceneCharacterActionSetNatural.push(_loc7_);
         var _loc8_:SceneCharacterStateItem = new SceneCharacterStateItem("natural",this._sceneCharacterSetNatural,this._sceneCharacterActionSetNatural);
         this._sceneCharacterStateSet.push(_loc8_);
         this.sceneCharacterStateWater();
      }
      
      private function sceneCharacterStateWater() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:Bitmap = null;
         var _loc3_:Sprite = null;
         this._sceneCharacterSetWater = new SceneCharacterSet();
         this._headMaskAsset = ComponentFactory.Instance.creat("asset.HotSpringPlayerBase.headMaskAsset");
         this._headMaskAsset.cacheAsBitmap = true;
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         _loc2_ = new Bitmap(_loc1_);
         _loc2_.cacheAsBitmap = true;
         _loc2_.mask = this._headMaskAsset;
         _loc3_ = new Sprite();
         _loc3_.addChild(_loc2_);
         _loc3_.addChild(this._headMaskAsset);
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.draw(_loc3_);
         if(_loc2_)
         {
            _loc2_.bitmapData.dispose();
         }
         _loc2_ = null;
         if(_loc3_ && _loc3_.parent)
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         _loc3_ = null;
         this._sceneCharacterSetWater.push(new SceneCharacterItem("WaterFrontHead","WaterFrontAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,1));
         this._rectangle.x = this.playerWitdh;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         _loc2_ = new Bitmap(_loc1_);
         _loc2_.cacheAsBitmap = true;
         _loc2_.mask = this._headMaskAsset;
         _loc3_ = new Sprite();
         _loc3_.addChild(_loc2_);
         _loc3_.addChild(this._headMaskAsset);
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.draw(_loc3_);
         if(_loc2_)
         {
            _loc2_.bitmapData.dispose();
         }
         _loc2_ = null;
         if(_loc3_ && _loc3_.parent)
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         _loc3_ = null;
         this._sceneCharacterSetWater.push(new SceneCharacterItem("WaterFrontEyesCloseHead","WaterFrontEyesCloseAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,2));
         this._rectangle.x = this.playerWitdh * 2;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         _loc2_ = new Bitmap(_loc1_);
         _loc2_.cacheAsBitmap = true;
         _loc2_.mask = this._headMaskAsset;
         _loc3_ = new Sprite();
         _loc3_.addChild(_loc2_);
         _loc3_.addChild(this._headMaskAsset);
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.draw(_loc3_);
         if(_loc2_)
         {
            _loc2_.bitmapData.dispose();
         }
         _loc2_ = null;
         if(_loc3_ && _loc3_.parent)
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         _loc3_ = null;
         if(this._headMaskAsset && this._headMaskAsset.parent)
         {
            this._headMaskAsset.parent.removeChild(this._headMaskAsset);
         }
         this._headMaskAsset = null;
         this._sceneCharacterSetWater.push(new SceneCharacterItem("WaterBackHead","WaterBackAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,6));
         this.sceneCharacterLoadBodyWater();
      }
      
      private function sceneCharacterLoadBodyWater() : void
      {
         this._sceneCharacterLoaderPath = "cloth3";
         this._sceneCharacterLoaderBody = new SceneCharacterLoaderBody(this._playerInfo,this._sceneCharacterLoaderPath);
         this._sceneCharacterLoaderBody.load(this.sceneCharacterLoaderBodyWaterCallBack);
      }
      
      private function sceneCharacterLoaderBodyWaterCallBack(param1:SceneCharacterLoaderBody, param2:Boolean = true) : void
      {
         var _loc3_:BitmapData = null;
         this._bodyBitmapData = param1.getContent()[0] as BitmapData;
         this._sceneCharacterLoaderPath = null;
         if(param1)
         {
            param1.dispose();
         }
         param1 = null;
         if(!param2 || !this._bodyBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false);
            }
            return;
         }
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this._bodyBitmapData.width;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetWater.push(new SceneCharacterItem("WaterFrontBody","WaterFrontAction",_loc3_,1,1,this.playerWitdh,this.playerHeight,3));
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetWater.push(new SceneCharacterItem("WaterFrontEyesCloseBody","WaterFrontEyesCloseAction",_loc3_,1,1,this.playerWitdh,this.playerHeight,4));
         this._rectangle.x = 0;
         this._rectangle.y = this.playerHeight;
         this._rectangle.width = this._bodyBitmapData.width;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetWater.push(new SceneCharacterItem("WaterBackBody","WaterBackAction",_loc3_,1,0,this.playerWitdh,this.playerHeight,5));
         var _loc4_:SceneCharacterActionItem = new SceneCharacterActionItem("waterFrontEyes",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],true);
         this._sceneCharacterActionSetWater.push(_loc4_);
         var _loc5_:SceneCharacterActionItem = new SceneCharacterActionItem("waterStandBack",[2],false);
         this._sceneCharacterActionSetWater.push(_loc5_);
         var _loc6_:SceneCharacterActionItem = new SceneCharacterActionItem("waterBack",[2],false);
         this._sceneCharacterActionSetWater.push(_loc6_);
         var _loc7_:SceneCharacterActionItem = new SceneCharacterActionItem("waterFront",[0],false);
         this._sceneCharacterActionSetWater.push(_loc7_);
         var _loc8_:SceneCharacterStateItem = new SceneCharacterStateItem("water",this._sceneCharacterSetWater,this._sceneCharacterActionSetWater);
         this._sceneCharacterStateSet.push(_loc8_);
         super.sceneCharacterStateSet = this._sceneCharacterStateSet;
      }
      
      override public function dispose() : void
      {
         this._playerInfo = null;
         if(this._sceneCharacterSetNatural)
         {
            this._sceneCharacterSetNatural.dispose();
         }
         this._sceneCharacterSetNatural = null;
         if(this._sceneCharacterSetWater)
         {
            this._sceneCharacterSetWater.dispose();
         }
         this._sceneCharacterSetWater = null;
         if(this._sceneCharacterLoaderHead)
         {
            this._sceneCharacterLoaderHead.dispose();
         }
         this._sceneCharacterLoaderHead = null;
         if(this._sceneCharacterLoaderBody)
         {
            this._sceneCharacterLoaderBody.dispose();
         }
         this._sceneCharacterLoaderBody = null;
         if(this._sceneCharacterActionSetNatural)
         {
            this._sceneCharacterActionSetNatural.dispose();
         }
         this._sceneCharacterActionSetNatural = null;
         if(this._sceneCharacterActionSetWater)
         {
            this._sceneCharacterActionSetWater.dispose();
         }
         this._sceneCharacterActionSetWater = null;
         if(this._sceneCharacterStateSet)
         {
            this._sceneCharacterStateSet.dispose();
         }
         this._sceneCharacterStateSet = null;
         if(this._headBitmapData)
         {
            this._headBitmapData.dispose();
         }
         this._headBitmapData = null;
         if(this._bodyBitmapData)
         {
            this._bodyBitmapData.dispose();
         }
         this._bodyBitmapData = null;
         if(this._headMaskAsset && this._headMaskAsset.parent)
         {
            this._headMaskAsset.parent.removeChild(this._headMaskAsset);
         }
         this._headMaskAsset = null;
         this._sceneCharacterLoaderPath = null;
         this._rectangle = null;
         super.dispose();
      }
   }
}
