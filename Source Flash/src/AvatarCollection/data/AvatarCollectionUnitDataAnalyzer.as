package AvatarCollection.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.data.DictionaryData;
   
   public class AvatarCollectionUnitDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _maleUnitDic:DictionaryData;
      
      private var _femaleUnitDic:DictionaryData;
      
      public function AvatarCollectionUnitDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:AvatarCollectionUnitVo = null;
         var _loc2_:XML = new XML(param1);
         this._maleUnitDic = new DictionaryData();
         this._femaleUnitDic = new DictionaryData();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new AvatarCollectionUnitVo();
               _loc5_.id = _loc3_[_loc4_].@ID;
               _loc5_.sex = _loc3_[_loc4_].@Sex;
               _loc5_.name = _loc3_[_loc4_].@Name;
               _loc5_.Attack = _loc3_[_loc4_].@Attack;
               _loc5_.Defence = _loc3_[_loc4_].@Defend;
               _loc5_.Agility = _loc3_[_loc4_].@Agility;
               _loc5_.Luck = _loc3_[_loc4_].@Luck;
               _loc5_.Damage = _loc3_[_loc4_].@Damage;
               _loc5_.Guard = _loc3_[_loc4_].@Guard;
               _loc5_.Blood = _loc3_[_loc4_].@Blood;
               _loc5_.needHonor = _loc3_[_loc4_].@Cost;
               if(_loc5_.sex == 1)
               {
                  this._maleUnitDic.add(_loc5_.id,_loc5_);
               }
               else
               {
                  this._femaleUnitDic.add(_loc5_.id,_loc5_);
               }
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get maleUnitDic() : DictionaryData
      {
         return this._maleUnitDic;
      }
      
      public function get femaleUnitDic() : DictionaryData
      {
         return this._femaleUnitDic;
      }
   }
}
