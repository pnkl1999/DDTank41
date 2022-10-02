package ddt.view.walkcharacter
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DisplayUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.view.character.ILayer;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class WalkCharacterLoader extends EventDispatcher implements Disposeable
   {
      
      public static const CellCharaterWidth:int = 120;
      
      public static const CellCharaterHeight:int = 175;
      
      private static const standFrams:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1];
      
      private static const backFrame:Array = [3];
      
      private static const walkFrontFrame:Array = [3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8];
      
      private static const walkBackFrame:Array = [10,10,10,11,11,11,12,12,12,13,13,13,14,14,14];
      
      public static const FrameLabels:Array = [{
         "frame":1,
         "name":"stand"
      },{
         "frame":standFrams.length - 1,
         "name":"gotoAndPlay(stand)"
      },{
         "frame":standFrams.length,
         "name":"back"
      },{
         "frame":standFrams.length + backFrame.length,
         "name":"walkfront"
      },{
         "frame":standFrams.length + backFrame.length + walkFrontFrame.length - 1,
         "name":"gotoAndPlay(walkfront)"
      },{
         "frame":standFrams.length + backFrame.length + walkFrontFrame.length,
         "name":"walkback"
      },{
         "frame":standFrams.length + backFrame.length + walkFrontFrame.length + walkBackFrame.length - 1,
         "name":"gotoAndPlay(walkback)"
      }];
      
      public static const UsedFrame:Array = standFrams.concat(backFrame,walkFrontFrame,walkBackFrame);
      
      public static const Stand:String = "stand";
      
      public static const Back:String = "back";
      
      public static const WalkFront:String = "walkfront";
      
      public static const WalkBack:String = "walkback";
       
      
      private var _resultBitmapData:BitmapData;
      
      private var _layers:Vector.<WalkCharaterLayer>;
      
      private var _playerInfo:PlayerInfo;
      
      private var _recordStyle:Array;
      
      private var _recordColor:Array;
      
      private var _clothPath:String;
      
      public function WalkCharacterLoader(param1:PlayerInfo, param2:String)
      {
         super();
         this._clothPath = param2;
         this._playerInfo = param1;
      }
      
      public function load() : void
      {
         this._layers = new Vector.<WalkCharaterLayer>();
         if(this._playerInfo == null || this._playerInfo.Style == null)
         {
            return;
         }
         this.initLoaders();
         var _loc1_:int = this._layers.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._layers[_loc2_].load(this.layerComplete);
            _loc2_++;
         }
      }
      
      private function initLoaders() : void
      {
         this._layers = new Vector.<WalkCharaterLayer>();
         this._recordStyle = this._playerInfo.Style.split(",");
         this._recordColor = this._playerInfo.Colors.split(",");
         this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])),this._recordColor[5]));
         this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[2].split("|")[0])),this._recordColor[2]));
         this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[3].split("|")[0])),this._recordColor[3]));
         this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])),this._recordColor[4],1,this._playerInfo.Sex,this._clothPath));
         this._layers.push(new WalkCharaterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])),this._recordColor[4],2,this._playerInfo.Sex,this._clothPath));
      }
      
      private function layerComplete(param1:ILayer) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this._layers.length)
         {
            if(!this._layers[_loc3_].isComplete)
            {
               _loc2_ = false;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            this.loadComplete();
         }
      }
      
      private function loadComplete() : void
      {
         var eff:BitmapData = null;
         var face:BitmapData = null;
         var hair:BitmapData = null;
         var clothFront:BitmapData = null;
         var clothBack:BitmapData = null;
         eff = null;
         face = null;
         hair = null;
         clothFront = null;
         clothBack = null;
         var drawFrame:Function = function(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int = 0):void
         {
            var _loc7_:Rectangle = new Rectangle();
            _loc7_.width = CellCharaterWidth;
            _loc7_.height = CellCharaterHeight;
            var _loc8_:Point = new Point();
            _loc8_.x = param1 * CellCharaterWidth;
            if(param2 <= 6)
            {
               _loc7_.x = param4 * CellCharaterWidth;
               _loc7_.y = 0;
               _loc8_.y = param6;
               _resultBitmapData.copyPixels(face,_loc7_,_loc8_,null,null,true);
               _loc7_.x = param3 * CellCharaterWidth;
               _resultBitmapData.copyPixels(hair,_loc7_,_loc8_,null,null,true);
               _loc7_.x = param5 * CellCharaterWidth;
               _resultBitmapData.copyPixels(eff,_loc7_,_loc8_,null,null,true);
               _loc7_.x = param2 * CellCharaterWidth;
               _loc8_.y = 0;
               _resultBitmapData.copyPixels(clothFront,_loc7_,_loc8_,null,null,true);
            }
            else
            {
               _loc7_.x = (param2 - 7) * CellCharaterWidth;
               _loc7_.y = CellCharaterHeight;
               _resultBitmapData.copyPixels(clothBack,_loc7_,_loc8_,null,null,true);
               _loc7_.x = param4 * CellCharaterWidth;
               _loc7_.y = 0;
               _loc8_.y = param6;
               _resultBitmapData.copyPixels(face,_loc7_,_loc8_,null,null,true);
               _loc7_.x = param3 * CellCharaterWidth;
               _resultBitmapData.copyPixels(hair,_loc7_,_loc8_,null,null,true);
               _loc7_.x = param5 * CellCharaterWidth;
               _resultBitmapData.copyPixels(eff,_loc7_,_loc8_,null,null,true);
            }
         };
         eff = DisplayUtils.getDisplayBitmapData(this._layers[2]);
         face = DisplayUtils.getDisplayBitmapData(this._layers[0]);
         hair = DisplayUtils.getDisplayBitmapData(this._layers[1]);
         clothFront = DisplayUtils.getDisplayBitmapData(this._layers[3]);
         clothBack = DisplayUtils.getDisplayBitmapData(this._layers[4]);
         this._resultBitmapData = new BitmapData(CellCharaterWidth * 15,CellCharaterHeight,true,16711680);
         drawFrame(0,0,0,0,0);
         drawFrame(1,0,1,1,1);
         drawFrame(2,7,2,2,2);
         drawFrame(3,1,0,0,0);
         drawFrame(4,2,0,0,0);
         drawFrame(5,3,0,0,0,2);
         drawFrame(6,4,0,0,0);
         drawFrame(7,5,0,0,0);
         drawFrame(8,6,0,0,0,2);
         drawFrame(9,8,2,2,2);
         drawFrame(10,9,2,2,2);
         drawFrame(11,10,2,2,2,2);
         drawFrame(12,11,2,2,2);
         drawFrame(13,12,2,2,2);
         drawFrame(14,13,2,2,2,2);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get content() : BitmapData
      {
         return this._resultBitmapData;
      }
      
      public function dispose() : void
      {
         this._resultBitmapData.dispose();
         var _loc1_:int = 0;
         while(_loc1_ < this._layers.length)
         {
            this._layers[_loc1_].dispose();
            _loc1_++;
         }
         this._layers = null;
         this._recordStyle = null;
         this._recordColor = null;
         this._playerInfo = null;
      }
   }
}
