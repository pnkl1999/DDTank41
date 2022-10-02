package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.store.FineSuitVo;
   import road7th.data.DictionaryData;
   
   public class FineSuitAnalyze extends DataAnalyzer
   {
       
      
      private var _list:DictionaryData;
      
      private var _data:DictionaryData;
      
      private var _materialIDList:Array;
      
      public function FineSuitAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:FineSuitVo = null;
         var _loc5_:FineSuitVo = null;
         var _loc6_:XML = new XML(param1);
         this._list = new DictionaryData();
         this._data = new DictionaryData();
         this._materialIDList = [];
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..SetsBuildTemp;
            if(_loc2_.length() > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length())
               {
                  _loc5_ = new FineSuitVo();
                  _loc5_.level = _loc2_[_loc3_].@Level;
                  _loc5_.type = _loc2_[_loc3_].@SetsType;
                  _loc5_.materialID = _loc2_[_loc3_].@UseItemTemplate;
                  _loc5_.exp = _loc2_[_loc3_].@Exp;
                  _loc5_.Defence = _loc2_[_loc3_].@DefenceGrow;
                  _loc5_.hp = _loc2_[_loc3_].@BloodGrow;
                  _loc5_.Luck = _loc2_[_loc3_].@LuckGrow;
                  _loc5_.Agility = _loc2_[_loc3_].@AgilityGrow;
                  _loc5_.MagicDefence = _loc2_[_loc3_].@MagicDefenceGrow;
                  _loc5_.Armor = _loc2_[_loc3_].@GuardGrow;
                  this._list.add(_loc5_.level,_loc5_);
                  if(_loc3_ % 14 == 0)
                  {
                     this._materialIDList.push(_loc5_.materialID);
                  }
                  this.addData(_loc5_);
                  _loc3_++;
               }
               _loc4_ = new FineSuitVo();
               _loc4_.materialID = this._list["1"].materialID;
               this._list.add("0",_loc4_);
               onAnalyzeComplete();
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc6_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function addData(param1:FineSuitVo) : void
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:int = param1.level % 14 == 0 ? int(int(14)) : int(int(param1.level % 14));
         var _loc4_:FineSuitVo = new FineSuitVo();
         if(!this._data.hasKey(param1.type))
         {
            _loc2_ = new DictionaryData();
            this._data.add(param1.type,_loc2_);
            ObjectUtils.copyProperties(_loc4_,param1);
            _loc2_.add("all",_loc4_);
         }
         else
         {
            _loc2_ = this._data[param1.type];
            _loc4_ = _loc2_["all"] as FineSuitVo;
            _loc4_.Defence += param1.Defence;
            _loc4_.hp += param1.hp;
            _loc4_.Luck += param1.Luck;
            _loc4_.Agility += param1.Agility;
            _loc4_.MagicDefence += param1.MagicDefence;
            _loc4_.Armor += param1.Armor;
         }
         _loc2_.add(_loc3_,param1);
      }
      
      public function get list() : DictionaryData
      {
         return this._list;
      }
      
      public function get materialIDList() : Array
      {
         return this._materialIDList;
      }
      
      public function get tipsData() : DictionaryData
      {
         return this._data;
      }
   }
}
