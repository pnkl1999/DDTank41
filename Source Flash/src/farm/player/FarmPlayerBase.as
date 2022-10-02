package farm.player
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.view.sceneCharacter.SceneCharacterActionItem;
   import ddt.view.sceneCharacter.SceneCharacterActionSet;
   import ddt.view.sceneCharacter.SceneCharacterItem;
   import ddt.view.sceneCharacter.SceneCharacterLoaderHead;
   import ddt.view.sceneCharacter.SceneCharacterPlayerBase;
   import ddt.view.sceneCharacter.SceneCharacterSet;
   import ddt.view.sceneCharacter.SceneCharacterStateItem;
   import ddt.view.sceneCharacter.SceneCharacterStateSet;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class FarmPlayerBase extends SceneCharacterPlayerBase
   {
       
      
      public var playerWitdh:Number = 120;
      
      public var playerHeight:Number = 175;
      
      private var _loadComplete:Boolean = false;
      
      private var _playerInfo:PlayerInfo;
      
      private var _callBack:Function;
      
      private var _sceneCharacterStateSet:SceneCharacterStateSet;
      
      private var _sceneCharacterActionSetNatural:SceneCharacterActionSet;
      
      private var _defaultSceneCharacterStateSet:SceneCharacterStateSet;
      
      private var _defaultSceneCharacterActionSetNatural:SceneCharacterActionSet;
      
      private var _defaultSceneCharacterSetNatural:SceneCharacterSet;
      
      private var _sceneCharacterSetNatural:SceneCharacterSet;
      
      private var _sceneCharacterLoaderHead:SceneCharacterLoaderHead;
      
      private var _sceneCharacterLoaderBody:FarmSceneCharacterLoaderLayer;
      
      private var _headBitmapData:BitmapData;
      
      private var _bodyBitmapData:BitmapData;
      
      private var _rectangle:Rectangle;
      
      public function FarmPlayerBase(param1:PlayerInfo, param2:Function = null)
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
         this._defaultSceneCharacterStateSet = new SceneCharacterStateSet();
         this._defaultSceneCharacterActionSetNatural = new SceneCharacterActionSet();
         this.sceneCharacterLoadHead();
      }
      
      private function sceneCharacterLoadHead() : void
      {
         this._sceneCharacterLoaderHead = new SceneCharacterLoaderHead(this._playerInfo);
         this._sceneCharacterLoaderHead.load(this.sceneCharacterLoaderHeadCallBack);
         if(!this._loadComplete)
         {
            this._headBitmapData = ComponentFactory.Instance.creatBitmapData("game.player.defaultPlayerCharacter");
            this.showDefaultCharacter();
         }
      }
      
      private function showDefaultCharacter() : void
      {
         var _loc1_:BitmapData = null;
         this._defaultSceneCharacterSetNatural = new SceneCharacterSet();
         if(!this._rectangle)
         {
            this._rectangle = new Rectangle();
         }
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(25,20));
         this._defaultSceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontHead","NaturalFrontAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,1));
         var _loc2_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandFront",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(_loc2_);
         var _loc3_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandBack",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(_loc3_);
         var _loc4_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkFront",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(_loc4_);
         var _loc5_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkBack",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(_loc5_);
         var _loc6_:SceneCharacterStateItem = new SceneCharacterStateItem("natural",this._defaultSceneCharacterSetNatural,this._defaultSceneCharacterActionSetNatural);
         this._defaultSceneCharacterStateSet.push(_loc6_);
         super.loadComplete = false;
         super.isDefaultCharacter = true;
         super.sceneCharacterStateSet = this._defaultSceneCharacterStateSet;
      }
      
      private function sceneCharacterLoaderHeadCallBack(param1:SceneCharacterLoaderHead, param2:Boolean = true) : void
      {
         this._headBitmapData = param1.getContent()[0] as BitmapData;
         if(param1)
         {
            param1.dispose();
         }
         if(!param2 || !this._headBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false,-1);
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
         if(!this._rectangle)
         {
            this._rectangle = new Rectangle();
         }
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
         this._sceneCharacterLoaderBody = new FarmSceneCharacterLoaderLayer(this._playerInfo);
         this._sceneCharacterLoaderBody.load(this.sceneCharacterLoaderBodyNaturalCallBack);
      }
      
      private function sceneCharacterLoaderBodyNaturalCallBack(param1:FarmSceneCharacterLoaderLayer, param2:Boolean) : void
      {
         var _loc3_:BitmapData = null;
         this._loadComplete = true;
         if(!this._sceneCharacterSetNatural)
         {
            return;
         }
         this._bodyBitmapData = param1.getContent()[0] as BitmapData;
         if(param1)
         {
            param1.dispose();
         }
         if(!param2 || !this._bodyBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false,-1);
            }
            return;
         }
         if(!this._rectangle)
         {
            this._rectangle = new Rectangle();
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
         super.loadComplete = true;
         super.isDefaultCharacter = false;
         super.sceneCharacterStateSet = this._sceneCharacterStateSet;
         this.disposeDefaultSource();
      }
      
      private function disposeDefaultSource() : void
      {
         if(this._defaultSceneCharacterStateSet)
         {
            this._defaultSceneCharacterStateSet.dispose();
         }
         this._defaultSceneCharacterStateSet = null;
         if(this._defaultSceneCharacterSetNatural)
         {
            this._defaultSceneCharacterSetNatural.dispose();
         }
         this._defaultSceneCharacterSetNatural = null;
         if(this._defaultSceneCharacterActionSetNatural)
         {
            this._defaultSceneCharacterActionSetNatural.dispose();
         }
         this._defaultSceneCharacterActionSetNatural = null;
      }
      
      override public function dispose() : void
      {
         this.disposeDefaultSource();
         this._playerInfo = null;
         this._callBack = null;
         if(this._sceneCharacterSetNatural)
         {
            this._sceneCharacterSetNatural.dispose();
         }
         this._sceneCharacterSetNatural = null;
         if(this._sceneCharacterActionSetNatural)
         {
            this._sceneCharacterActionSetNatural.dispose();
         }
         this._sceneCharacterActionSetNatural = null;
         if(this._sceneCharacterStateSet)
         {
            this._sceneCharacterStateSet.dispose();
         }
         this._sceneCharacterStateSet = null;
         ObjectUtils.disposeObject(this._sceneCharacterLoaderBody);
         this._sceneCharacterLoaderBody = null;
         ObjectUtils.disposeObject(this._sceneCharacterLoaderHead);
         this._sceneCharacterLoaderHead = null;
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
         this._rectangle = null;
         super.dispose();
      }
   }
}
