package AvatarCollection.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.data.DictionaryData;
   
   public class AvatarCollectionItemDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _maleItemDic:DictionaryData;
      
      private var _femaleItemDic:DictionaryData;
      
      private var _maleItemList:Vector.<AvatarCollectionItemVo>;
      
      private var _femaleItemList:Vector.<AvatarCollectionItemVo>;
      
      public function AvatarCollectionItemDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:AvatarCollectionItemVo = null;
         var _loc6_:int = 0;
         var _loc2_:XML = new XML(param1);
         this._maleItemDic = new DictionaryData();
         this._femaleItemDic = new DictionaryData();
         this._maleItemList = new Vector.<AvatarCollectionItemVo>();
         this._femaleItemList = new Vector.<AvatarCollectionItemVo>();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new AvatarCollectionItemVo();
               _loc5_.id = _loc3_[_loc4_].@ID;
               _loc5_.itemId = _loc3_[_loc4_].@TemplateID;
               _loc5_.proArea = _loc3_[_loc4_].@Description;
               _loc5_.needGold = _loc3_[_loc4_].@Cost;
               _loc5_.sex = _loc3_[_loc4_].@Sex;
               _loc6_ = _loc5_.id;
               if(_loc5_.sex == 1)
               {
                  if(!this._maleItemDic[_loc6_])
                  {
                     this._maleItemDic[_loc6_] = new DictionaryData();
                  }
                  this._maleItemDic[_loc6_].add(_loc5_.itemId,_loc5_);
                  this._maleItemList.push(_loc5_);
               }
               else
               {
                  if(!this._femaleItemDic[_loc6_])
                  {
                     this._femaleItemDic[_loc6_] = new DictionaryData();
                  }
                  this._femaleItemDic[_loc6_].add(_loc5_.itemId,_loc5_);
                  this._femaleItemList.push(_loc5_);
               }
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
         }
      }
      
      public function get maleItemDic() : DictionaryData
      {
         return this._maleItemDic;
      }
      
      public function get femaleItemDic() : DictionaryData
      {
         return this._femaleItemDic;
      }
      
      public function get maleItemList() : Vector.<AvatarCollectionItemVo>
      {
         return this._maleItemList;
      }
      
      public function get femaleItemList() : Vector.<AvatarCollectionItemVo>
      {
         return this._femaleItemList;
      }
   }
}
