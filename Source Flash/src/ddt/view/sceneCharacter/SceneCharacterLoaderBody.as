package ddt.view.sceneCharacter
{
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.view.character.ILayer;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   
   public class SceneCharacterLoaderBody
   {
       
      
      private var _loaders:Vector.<SceneCharacterLayer>;
      
      private var _recordStyle:Array;
      
      private var _recordColor:Array;
      
      private var _content:BitmapData;
      
      private var _completeCount:int;
      
      private var _playerInfo:PlayerInfo;
      
      private var _sceneCharacterLoaderPath:String;
      
      private var _isAllLoadSucceed:Boolean = true;
      
      private var _callBack:Function;
      
      public function SceneCharacterLoaderBody(param1:PlayerInfo, param2:String = null)
      {
         super();
         this._playerInfo = param1;
         this._sceneCharacterLoaderPath = param2;
      }
      
      public function load(param1:Function = null) : void
      {
         this._callBack = param1;
         if(this._playerInfo == null || this._playerInfo.Style == null)
         {
            return;
         }
         this.initLoaders();
         var _loc2_:int = this._loaders.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._loaders[_loc3_].load(this.layerComplete);
            _loc3_++;
         }
      }
      
      private function initLoaders() : void
      {
         this._loaders = new Vector.<SceneCharacterLayer>();
         this._recordStyle = this._playerInfo.Style.split(",");
         this._recordColor = this._playerInfo.Colors.split(",");
         this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])),this._recordColor[4],1,this._playerInfo.Sex,this._sceneCharacterLoaderPath));
         this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])),this._recordColor[4],2,this._playerInfo.Sex,this._sceneCharacterLoaderPath));
      }
      
      private function drawCharacter() : void
      {
         var _loc1_:Number = this._loaders[0].width;
         var _loc2_:Number = this._loaders[0].height;
         if(_loc1_ == 0 || _loc2_ == 0)
         {
            return;
         }
         this._content = new BitmapData(_loc1_,_loc2_,true,0);
         var _loc3_:uint = 0;
         while(_loc3_ < this._loaders.length)
         {
            if(!this._loaders[_loc3_].isAllLoadSucceed)
            {
               this._isAllLoadSucceed = false;
            }
            this._content.draw(this._loaders[_loc3_].getContent(),null,null,BlendMode.NORMAL);
            _loc3_++;
         }
      }
      
      private function layerComplete(param1:ILayer) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this._loaders.length)
         {
            if(!this._loaders[_loc3_].isComplete)
            {
               _loc2_ = false;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            this.drawCharacter();
            this.loadComplete();
         }
      }
      
      private function loadComplete() : void
      {
         if(this._callBack != null)
         {
            this._callBack(this,this._isAllLoadSucceed);
         }
      }
      
      public function getContent() : Array
      {
         return [this._content];
      }
      
      public function dispose() : void
      {
         if(this._loaders == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._loaders.length)
         {
            this._loaders[_loc1_].dispose();
            _loc1_++;
         }
         this._loaders = null;
         this._recordStyle = null;
         this._recordColor = null;
         this._playerInfo = null;
         this._callBack = null;
         this._sceneCharacterLoaderPath = null;
      }
   }
}
