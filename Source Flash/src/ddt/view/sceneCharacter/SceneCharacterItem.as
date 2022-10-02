package ddt.view.sceneCharacter
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class SceneCharacterItem
   {
       
      
      private var _type:String;
      
      private var _groupType:String;
      
      private var _sortOrder:int;
      
      private var _source:BitmapData;
      
      private var _points:Vector.<Point>;
      
      private var _cellWitdh:Number;
      
      private var _cellHeight:Number;
      
      private var _rowNumber:int;
      
      private var _rowCellNumber:int;
      
      private var _isRepeat:Boolean;
      
      private var _repeatNumber:int;
      
      public function SceneCharacterItem(param1:String, param2:String, param3:BitmapData, param4:int, param5:int, param6:Number, param7:Number, param8:int = 0, param9:Vector.<Point> = null, param10:Boolean = false, param11:int = 0)
      {
         super();
         this._type = param1;
         this._groupType = param2;
         this._source = param3;
         this._rowNumber = param4;
         this._rowCellNumber = param5;
         this._cellWitdh = param6;
         this._cellHeight = param7;
         this._points = param9;
         this._sortOrder = param8;
         this._isRepeat = param10;
         this._repeatNumber = param11;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get groupType() : String
      {
         return this._groupType;
      }
      
      public function get source() : BitmapData
      {
         return this._source;
      }
      
      public function set source(param1:BitmapData) : void
      {
         this._source = param1;
      }
      
      public function get points() : Vector.<Point>
      {
         return this._points;
      }
      
      public function get cellWitdh() : Number
      {
         return this._cellWitdh;
      }
      
      public function get cellHeight() : Number
      {
         return this._cellHeight;
      }
      
      public function get rowNumber() : int
      {
         return this._rowNumber;
      }
      
      public function set rowNumber(param1:int) : void
      {
         this._rowNumber = param1;
      }
      
      public function get rowCellNumber() : int
      {
         return this._rowCellNumber;
      }
      
      public function set rowCellNumber(param1:int) : void
      {
         this._rowCellNumber = param1;
      }
      
      public function get sortOrder() : int
      {
         return this._sortOrder;
      }
      
      public function get isRepeat() : Boolean
      {
         return this._isRepeat;
      }
      
      public function get repeatNumber() : int
      {
         return this._repeatNumber;
      }
      
      public function dispose() : void
      {
         if(this._source)
         {
            this._source.dispose();
         }
         this._source = null;
         while(this._points && this._points.length > 0)
         {
            this._points.shift();
         }
         this._points = null;
      }
   }
}
