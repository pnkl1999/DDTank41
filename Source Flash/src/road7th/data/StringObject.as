package road7th.data
{
   public class StringObject
   {
       
      
      private var _data:String;
      
      public function StringObject(param1:String = "")
      {
         super();
         this._data = param1;
      }
      
      public function get isBoolean() : Boolean
      {
         var _loc1_:String = this._data.toLowerCase();
         return this._data == "true" || this._data == "false";
      }
      
      public function get isInt() : Boolean
      {
         var _loc1_:RegExp = /^-?\d+$/;
         return _loc1_.test(this._data);
      }
      
      public function getBoolean() : Boolean
      {
         if("true" == this._data || "True" == this._data)
         {
            return true;
         }
         if("false" == this._data || "False" == this._data)
         {
            return false;
         }
         if("" == this._data)
         {
            return false;
         }
         return true;
      }
      
      public function getInt() : int
      {
         return int(this._data);
      }
      
      public function getNumber() : Number
      {
         return Number(this._data);
      }
   }
}
