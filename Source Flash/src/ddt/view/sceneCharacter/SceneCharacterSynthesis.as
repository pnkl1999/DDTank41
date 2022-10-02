package ddt.view.sceneCharacter
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SceneCharacterSynthesis
   {
       
      
      private var _sceneCharacterSet:SceneCharacterSet;
      
      private var _frameBitmap:Vector.<Bitmap>;
      
      private var _callBack:Function;
      
      public function SceneCharacterSynthesis(param1:SceneCharacterSet, param2:Function)
      {
         this._frameBitmap = new Vector.<Bitmap>();
         super();
         this._sceneCharacterSet = param1;
         this._callBack = param2;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.characterSynthesis();
      }
      
      private function characterSynthesis() : void
      {
         var _loc4_:SceneCharacterItem = null;
         var _loc5_:SceneCharacterItem = null;
         var _loc6_:BitmapData = null;
         var _loc7_:int = 0;
         var _loc8_:BitmapData = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Point = null;
         var _loc1_:Matrix = new Matrix();
         var _loc2_:Point = new Point(0,0);
         var _loc3_:Rectangle = new Rectangle();
         for each(_loc4_ in this._sceneCharacterSet.dataSet)
         {
            if(_loc4_.isRepeat)
            {
               _loc6_ = new BitmapData(_loc4_.source.width * _loc4_.repeatNumber,_loc4_.source.height,true,0);
               _loc7_ = 0;
               while(_loc7_ < _loc4_.repeatNumber)
               {
                  _loc1_.tx = _loc4_.source.width * _loc7_;
                  _loc6_.draw(_loc4_.source,_loc1_);
                  _loc7_++;
               }
               _loc4_.source.dispose();
               _loc4_.source = null;
               _loc4_.source = new BitmapData(_loc6_.width,_loc6_.height,true,0);
               _loc4_.source.draw(_loc6_);
               _loc6_.dispose();
               _loc6_ = null;
            }
            if(_loc4_.points && _loc4_.points.length > 0)
            {
               _loc8_ = new BitmapData(_loc4_.source.width,_loc4_.source.height,true,0);
               _loc8_.draw(_loc4_.source);
               _loc4_.source.dispose();
               _loc4_.source = null;
               _loc4_.source = new BitmapData(_loc8_.width,_loc8_.height,true,0);
               _loc3_.width = _loc4_.cellWitdh;
               _loc3_.height = _loc4_.cellHeight;
               _loc9_ = 0;
               while(_loc9_ < _loc4_.rowNumber)
               {
                  _loc10_ = !!_loc4_.isRepeat ? int(int(_loc4_.repeatNumber)) : int(int(_loc4_.rowCellNumber));
                  _loc11_ = 0;
                  while(_loc11_ < _loc10_)
                  {
                     _loc12_ = _loc4_.points[_loc9_ * _loc10_ + _loc11_];
                     if(_loc12_)
                     {
                        _loc2_.x = _loc4_.cellWitdh * _loc11_ + _loc12_.x;
                        _loc2_.y = _loc4_.cellHeight * _loc9_ + _loc12_.y;
                        _loc3_.x = _loc4_.cellWitdh * _loc11_;
                        _loc3_.y = _loc4_.cellHeight * _loc9_;
                        _loc4_.source.copyPixels(_loc8_,_loc3_,_loc2_);
                     }
                     else
                     {
                        _loc2_.x = _loc3_.x = _loc4_.cellWitdh * _loc11_;
                        _loc2_.y = _loc3_.y = _loc4_.cellHeight * _loc9_;
                        _loc4_.source.copyPixels(_loc8_,_loc3_,_loc2_);
                     }
                     _loc11_++;
                  }
                  _loc9_++;
               }
               _loc8_.dispose();
               _loc8_ = null;
            }
         }
         for each(_loc5_ in this._sceneCharacterSet.dataSet)
         {
            this.characterGroupDraw(_loc5_);
         }
         this.characterDraw();
      }
      
      private function characterGroupDraw(param1:SceneCharacterItem) : void
      {
         var _loc2_:SceneCharacterItem = null;
         for each(_loc2_ in this._sceneCharacterSet.dataSet)
         {
            if(param1.groupType == _loc2_.groupType && _loc2_.type != param1.type)
            {
               param1.source.draw(_loc2_.source);
               param1.rowNumber = _loc2_.rowNumber > param1.rowNumber ? int(int(_loc2_.rowNumber)) : int(int(param1.rowNumber));
               param1.rowCellNumber = _loc2_.rowCellNumber > param1.rowCellNumber ? int(int(_loc2_.rowCellNumber)) : int(int(param1.rowCellNumber));
               this._sceneCharacterSet.dataSet.splice(this._sceneCharacterSet.dataSet.indexOf(_loc2_),1);
            }
         }
      }
      
      private function characterDraw() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:SceneCharacterItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc2_ in this._sceneCharacterSet.dataSet)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.rowNumber)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.rowCellNumber)
               {
                  _loc1_ = new BitmapData(_loc2_.cellWitdh,_loc2_.cellHeight,true,0);
                  _loc1_.copyPixels(_loc2_.source,new Rectangle(_loc4_ * _loc2_.cellWitdh,_loc2_.cellHeight * _loc3_,_loc2_.cellWitdh,_loc2_.cellHeight),new Point(0,0));
                  this._frameBitmap.push(new Bitmap(_loc1_));
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         if(this._callBack != null)
         {
            this._callBack(this._frameBitmap);
         }
      }
      
      public function dispose() : void
      {
         if(this._sceneCharacterSet)
         {
            this._sceneCharacterSet.dispose();
         }
         this._sceneCharacterSet = null;
         while(this._frameBitmap && this._frameBitmap.length > 0)
         {
            this._frameBitmap[0].bitmapData.dispose();
            this._frameBitmap[0].bitmapData = null;
            this._frameBitmap.shift();
         }
         this._frameBitmap = null;
         this._callBack = null;
      }
   }
}
