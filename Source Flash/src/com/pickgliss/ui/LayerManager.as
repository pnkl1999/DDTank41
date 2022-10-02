package com.pickgliss.ui
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.SpriteLayer;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   
   public class LayerManager
   {
      
      public static const STAGE_TOP_LAYER:int = 0;
      
      public static const STAGE_DYANMIC_LAYER:int = 1;
      
      public static const GAME_TOP_LAYER:int = 2;
      
      public static const GAME_DYNAMIC_LAYER:int = 3;
      
      public static const GAME_UI_LAYER:int = 4;
      
      public static const GAME_BASE_LAYER:int = 5;
      
      public static const GAME_BOTTOM_LAYER:int = 6;
      
      public static const STAGE_BOTTOM_LAYER:int = 7;
      
      public static const NONE_BLOCKGOUND:int = 0;
      
      public static const BLCAK_BLOCKGOUND:int = 1;
      
      public static const ALPHA_BLOCKGOUND:int = 2;
      
      private static var _instance:LayerManager;
       
      
      private var _stageTopLayer:SpriteLayer;
      
      private var _stageDynamicLayer:SpriteLayer;
      
      private var _stageBottomLayer:SpriteLayer;
      
      private var _gameTopLayer:SpriteLayer;
      
      private var _gameDynamicLayer:SpriteLayer;
      
      private var _gameUILayer:SpriteLayer;
      
      private var _gameBaseLayer:SpriteLayer;
      
      private var _gameBottomLayer:SpriteLayer;
      
      public function LayerManager()
      {
         super();
      }
      
      public static function get Instance() : LayerManager
      {
         if(_instance == null)
         {
            _instance = new LayerManager();
         }
         return _instance;
      }
      
      public function setup(param1:Stage) : void
      {
         this._stageTopLayer = new SpriteLayer();
         this._stageDynamicLayer = new SpriteLayer();
         this._stageBottomLayer = new SpriteLayer(true);
         this._gameTopLayer = new SpriteLayer();
         this._gameDynamicLayer = new SpriteLayer();
         this._gameUILayer = new SpriteLayer();
         this._gameBaseLayer = new SpriteLayer();
         this._gameBottomLayer = new SpriteLayer();
         param1.addChild(this._stageBottomLayer);
         param1.addChild(this._stageDynamicLayer);
         param1.addChild(this._stageTopLayer);
         this._gameDynamicLayer.autoClickTotop = true;
         this._stageBottomLayer.addChild(this._gameBottomLayer);
         this._stageBottomLayer.addChild(this._gameBaseLayer);
         this._stageBottomLayer.addChild(this._gameUILayer);
         this._stageBottomLayer.addChild(this._gameDynamicLayer);
         this._stageBottomLayer.addChild(this._gameTopLayer);
      }
      
      public function getLayerByType(param1:int) : SpriteLayer
      {
         switch(param1)
         {
            case STAGE_TOP_LAYER:
               return this._stageTopLayer;
            case STAGE_DYANMIC_LAYER:
               return this._stageDynamicLayer;
            case GAME_TOP_LAYER:
               return this._gameTopLayer;
            case GAME_DYNAMIC_LAYER:
               return this._gameDynamicLayer;
            case GAME_BASE_LAYER:
               return this._gameBaseLayer;
            case GAME_BOTTOM_LAYER:
               return this._gameBottomLayer;
            case GAME_UI_LAYER:
               return this._gameUILayer;
            case STAGE_BOTTOM_LAYER:
               return this._stageBottomLayer;
            default:
               return null;
         }
      }
      
      public function addToLayer(param1:DisplayObject, param2:int, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         var _loc7_:Rectangle = null;
         _loc7_ = null;
         var _loc6_:SpriteLayer = this.getLayerByType(param2);
         if(param3)
         {
            if(param1 is Component)
            {
               param1.x = (StageReferance.stageWidth - param1.width) / 2;
               param1.y = (StageReferance.stageHeight - param1.height) / 2;
            }
            else
            {
               _loc7_ = DisplayUtils.getVisibleSize(param1);
               param1.x = (StageReferance.stageWidth - _loc7_.width) / 2;
               param1.y = (StageReferance.stageHeight - _loc7_.height) / 2;
            }
         }
         _loc6_.addTolayer(param1,param4,param5);
      }
      
      public function clearnStageDynamic() : void
      {
         this.cleanSprite(this._stageDynamicLayer);
      }
      
      public function clearnGameDynamic() : void
      {
         this.cleanSprite(this._gameDynamicLayer);
      }
      
      private function cleanSprite(param1:Sprite) : void
      {
         var _loc2_:DisplayObject = null;
         while(param1.numChildren > 0)
         {
            _loc2_ = param1.getChildAt(0);
            ObjectUtils.disposeObject(_loc2_);
         }
      }
      
      public function get backGroundInParent() : Boolean
      {
         if(!this._stageTopLayer.backGroundInParent && !this._stageDynamicLayer.backGroundInParent && !this._stageBottomLayer.backGroundInParent && !this._gameTopLayer.backGroundInParent && !this._gameDynamicLayer.backGroundInParent && !this._gameUILayer.backGroundInParent && !this._gameBaseLayer.backGroundInParent && !this._gameBottomLayer.backGroundInParent)
         {
            return false;
         }
         return true;
      }
   }
}
