package church.vo
{
   public class FatherBallConfigVO
   {
       
      
      private var _isMask:String;
      
      private var _rowNumber:int;
      
      private var _rowWitdh:Number;
      
      private var _rowHeight:Number;
      
      private var _frameStep:Number;
      
      private var _sleepSecond:int;
      
      public function FatherBallConfigVO()
      {
         super();
      }
      
      public function get isMask() : String
      {
         return this._isMask;
      }
      
      public function set isMask(param1:String) : void
      {
         this._isMask = param1;
      }
      
      public function get sleepSecond() : int
      {
         return this._sleepSecond;
      }
      
      public function set sleepSecond(param1:int) : void
      {
         this._sleepSecond = param1;
      }
      
      public function get frameStep() : Number
      {
         return this._frameStep;
      }
      
      public function set frameStep(param1:Number) : void
      {
         this._frameStep = param1;
      }
      
      public function get rowHeight() : Number
      {
         return this._rowHeight;
      }
      
      public function set rowHeight(param1:Number) : void
      {
         this._rowHeight = param1;
      }
      
      public function get rowWitdh() : Number
      {
         return this._rowWitdh;
      }
      
      public function set rowWitdh(param1:Number) : void
      {
         this._rowWitdh = param1;
      }
      
      public function get rowNumber() : int
      {
         return this._rowNumber;
      }
      
      public function set rowNumber(param1:int) : void
      {
         this._rowNumber = param1;
      }
   }
}
