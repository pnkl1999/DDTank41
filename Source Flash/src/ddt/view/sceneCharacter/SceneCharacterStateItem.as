package ddt.view.sceneCharacter
{
   import flash.display.Bitmap;
   
   public class SceneCharacterStateItem
   {
       
      
      private var _type:String;
      
      private var _sceneCharacterSet:SceneCharacterSet;
      
      private var _sceneCharacterActionSet:SceneCharacterActionSet;
      
      private var _sceneCharacterSynthesis:SceneCharacterSynthesis;
      
      private var _sceneCharacterBase:SceneCharacterBase;
      
      private var _frameBitmap:Vector.<Bitmap>;
      
      private var _sceneCharacterActionItem:SceneCharacterActionItem;
      
      private var _sceneCharacterDirection:SceneCharacterDirection;
      
      public function SceneCharacterStateItem(param1:String, param2:SceneCharacterSet, param3:SceneCharacterActionSet)
      {
         super();
         this._type = param1;
         this._sceneCharacterSet = param2;
         this._sceneCharacterActionSet = param3;
      }
      
      public function update() : void
      {
         if(!this._sceneCharacterSet || !this._sceneCharacterActionSet)
         {
            return;
         }
         if(this._sceneCharacterSynthesis)
         {
            this._sceneCharacterSynthesis.dispose();
         }
         this._sceneCharacterSynthesis = null;
         this._sceneCharacterSynthesis = new SceneCharacterSynthesis(this._sceneCharacterSet,this.sceneCharacterSynthesisCallBack);
      }
      
      private function sceneCharacterSynthesisCallBack(param1:Vector.<Bitmap>) : void
      {
         this._frameBitmap = param1;
         if(this._sceneCharacterBase)
         {
            this._sceneCharacterBase.dispose();
         }
         this._sceneCharacterBase = null;
         this._sceneCharacterBase = new SceneCharacterBase(this._frameBitmap);
         this._sceneCharacterBase.sceneCharacterActionItem = this._sceneCharacterActionItem = this._sceneCharacterActionSet.dataSet[0];
      }
      
      public function set setSceneCharacterActionType(param1:String) : void
      {
         var _loc2_:SceneCharacterActionItem = this._sceneCharacterActionSet.getItem(param1);
         if(_loc2_)
         {
            this._sceneCharacterActionItem = _loc2_;
         }
         this._sceneCharacterBase.sceneCharacterActionItem = this._sceneCharacterActionItem;
      }
      
      public function get setSceneCharacterActionType() : String
      {
         return this._sceneCharacterActionItem.type;
      }
      
      public function set sceneCharacterDirection(param1:SceneCharacterDirection) : void
      {
         if(this._sceneCharacterDirection == param1)
         {
            return;
         }
         this._sceneCharacterDirection = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function get sceneCharacterSet() : SceneCharacterSet
      {
         return this._sceneCharacterSet;
      }
      
      public function set sceneCharacterSet(param1:SceneCharacterSet) : void
      {
         this._sceneCharacterSet = param1;
      }
      
      public function get sceneCharacterBase() : SceneCharacterBase
      {
         return this._sceneCharacterBase;
      }
      
      public function dispose() : void
      {
         if(this._sceneCharacterSet)
         {
            this._sceneCharacterSet.dispose();
         }
         this._sceneCharacterSet = null;
         if(this._sceneCharacterActionSet)
         {
            this._sceneCharacterActionSet.dispose();
         }
         this._sceneCharacterActionSet = null;
         if(this._sceneCharacterSynthesis)
         {
            this._sceneCharacterSynthesis.dispose();
         }
         this._sceneCharacterSynthesis = null;
         if(this._sceneCharacterBase)
         {
            this._sceneCharacterBase.dispose();
         }
         this._sceneCharacterBase = null;
         if(this._sceneCharacterActionItem)
         {
            this._sceneCharacterActionItem.dispose();
         }
         this._sceneCharacterActionItem = null;
         this._sceneCharacterDirection = null;
         while(this._frameBitmap && this._frameBitmap.length > 0)
         {
            this._frameBitmap[0].bitmapData.dispose();
            this._frameBitmap[0].bitmapData = null;
            this._frameBitmap.shift();
         }
         this._frameBitmap = null;
      }
   }
}
