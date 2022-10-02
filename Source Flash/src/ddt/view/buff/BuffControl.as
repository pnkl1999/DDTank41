package ddt.view.buff
{
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.manager.PlayerManager;
   import ddt.view.buff.buffButton.BuffButton;
   import ddt.view.buff.buffButton.LabyrinthBuffButton;
   import ddt.view.buff.buffButton.PayBuffButton;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class BuffControl extends Sprite
   {
       
      
      private var _buffData:DictionaryData;
      
      private var _buffList:HBox;
      
      private var _buffBtnArr:Array;
      
      private var _str:String;
      
      private var _labyrinthBuff:LabyrinthBuffButton;
      
      public function BuffControl(param1:String = "")
      {
         super();
         this._str = param1;
         this.init();
         this.initEvents();
      }
      
      public static function isPayBuff(param1:BuffInfo) : Boolean
      {
         switch(param1.Type)
         {
            case BuffInfo.Caddy_Good:
            case BuffInfo.Save_Life:
            case BuffInfo.Agility:
            case BuffInfo.ReHealth:
            case BuffInfo.Train_Good:
            case BuffInfo.Level_Try:
            case BuffInfo.Card_Get:
               return true;
            default:
               return false;
         }
      }
      
      private function init() : void
      {
         this._buffData = PlayerManager.Instance.Self.buffInfo;
         this._buffList = new HBox();
         this._buffList.spacing = 1;
         addChild(this._buffList);
         this.initBuffButtons();
      }
      
      private function initEvents() : void
      {
         this._buffData.addEventListener(DictionaryEvent.ADD,this.__addBuff);
         this._buffData.addEventListener(DictionaryEvent.REMOVE,this.__removeBuff);
         this._buffData.addEventListener(DictionaryEvent.UPDATE,this.__addBuff);
      }
      
      private function removeEvents() : void
      {
         if(this._buffData)
         {
            this._buffData.removeEventListener(DictionaryEvent.ADD,this.__addBuff);
            this._buffData.removeEventListener(DictionaryEvent.REMOVE,this.__removeBuff);
            this._buffData.removeEventListener(DictionaryEvent.UPDATE,this.__addBuff);
         }
      }
      
      private function initBuffButtons() : void
      {
         var _loc2_:BuffButton = null;
         this._buffBtnArr = [];
         var _loc1_:int = 1;
         while(_loc1_ <= 4)
         {
            if(_loc1_ < 4)
            {
               _loc2_ = BuffButton.createBuffButton(_loc1_);
               if(this._str == "")
               {
                  this._buffList.addChild(_loc2_);
               }
            }
            else
            {
               _loc2_ = BuffButton.createBuffButton(_loc1_,this._str);
               this._buffList.addChild(_loc2_);
            }
            this._buffBtnArr.push(_loc2_);
            _loc1_++;
         }
         this.setInfo(this._buffData);
         this.addLabyrinthBuff();
      }
      
      private function addLabyrinthBuff() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this._buffData)
         {
            if(this._buffData[_loc1_] != null)
            {
               if(this._buffData[_loc1_].Type >= 74 && this._buffData[_loc1_].Type <= 80)
               {
                  if(!this._labyrinthBuff)
                  {
                     this._labyrinthBuff = new LabyrinthBuffButton();
                     this._buffList.addChild(this._labyrinthBuff);
                     break;
                  }
               }
            }
         }
      }
      
      public function setInfo(param1:DictionaryData) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            if(param1[_loc2_] == null)
            {
               continue;
            }
            switch(param1[_loc2_].Type)
            {
               case BuffInfo.DOUBEL_EXP:
                  this._buffBtnArr[0].info = param1[_loc2_];
                  break;
               case BuffInfo.DOUBLE_GESTE:
                  this._buffBtnArr[1].info = param1[_loc2_];
                  break;
               case BuffInfo.PREVENT_KICK:
                  this._buffBtnArr[2].info = param1[_loc2_];
                  break;
               case BuffInfo.Caddy_Good:
               case BuffInfo.Save_Life:
               case BuffInfo.Agility:
               case BuffInfo.ReHealth:
               case BuffInfo.Train_Good:
               case BuffInfo.Level_Try:
               case BuffInfo.Card_Get:
                  PayBuffButton(this._buffBtnArr[3]).addBuff(param1[_loc2_]);
                  break;
            }
         }
      }
      
      private function __addBuff(param1:DictionaryEvent) : void
      {
         var _loc2_:BuffInfo = param1.data as BuffInfo;
         switch(_loc2_.Type)
         {
            case BuffInfo.DOUBEL_EXP:
               this.setBuffButtonInfo(0,_loc2_);
               break;
            case BuffInfo.DOUBLE_GESTE:
               this.setBuffButtonInfo(1,_loc2_);
               break;
            case BuffInfo.PREVENT_KICK:
               this.setBuffButtonInfo(2,_loc2_);
               break;
            case BuffInfo.Caddy_Good:
            case BuffInfo.Save_Life:
            case BuffInfo.Agility:
            case BuffInfo.ReHealth:
            case BuffInfo.Train_Good:
            case BuffInfo.Level_Try:
            case BuffInfo.Card_Get:
               PayBuffButton(this._buffBtnArr[3]).addBuff(_loc2_);
               break;
            case BuffInfo.PropertyWater_74:
            case BuffInfo.PropertyWater_74 + 1:
            case BuffInfo.PropertyWater_74 + 2:
            case BuffInfo.PropertyWater_74 + 3:
            case BuffInfo.PropertyWater_74 + 4:
            case BuffInfo.PropertyWater_74 + 5:
            case BuffInfo.PropertyWater_74 + 6:
               if(!this._labyrinthBuff)
               {
                  this._labyrinthBuff = new LabyrinthBuffButton();
                  this._buffList.addChild(this._labyrinthBuff);
               }
         }
      }
      
      private function setBuffButtonInfo(param1:int, param2:BuffInfo) : void
      {
         if(param2.IsExist)
         {
            this._buffBtnArr[param1].info = param2;
         }
         else
         {
            this._buffBtnArr[param1].isExist = false;
         }
      }
      
      private function __removeBuff(param1:DictionaryEvent) : void
      {
         switch((param1.data as BuffInfo).Type)
         {
            case BuffInfo.DOUBEL_EXP:
               this._buffBtnArr[0].info = new BuffInfo(BuffInfo.DOUBEL_EXP);
               break;
            case BuffInfo.DOUBLE_GESTE:
               this._buffBtnArr[1].info = new BuffInfo(BuffInfo.DOUBLE_GESTE);
               break;
            case BuffInfo.PREVENT_KICK:
               this._buffBtnArr[2].info = new BuffInfo(BuffInfo.PREVENT_KICK);
         }
      }
      
      private function __updateBuff(param1:DictionaryEvent) : void
      {
      }
      
      public function set CanClick(param1:Boolean) : void
      {
         var _loc2_:BuffButton = null;
         for each(_loc2_ in this._buffBtnArr)
         {
            _loc2_.CanClick = param1;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._buffList)
         {
            ObjectUtils.disposeObject(this._buffList);
            this._buffList = null;
         }
         if(this._labyrinthBuff)
         {
            this._labyrinthBuff.dispose();
            this._labyrinthBuff = null;
         }
         this._buffData = null;
         this._buffBtnArr = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get buffList() : HBox
      {
         return this._buffList;
      }
   }
}
