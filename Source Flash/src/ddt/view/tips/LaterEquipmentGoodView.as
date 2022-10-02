package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipSuitTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.data.goods.SuitTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   
   public class LaterEquipmentGoodView extends Component
   {
      
      public static const THISWIDTH:int = 200;
      
      public static const EQUIPNUM:int = 19;
      
      public static var isShow:Boolean = true;
       
      
      private var SUITNUM:int;
      
      private var _bg:ScaleBitmapImage;
      
      private var _topName:FilterFrameText;
      
      private var _setNum:FilterFrameText;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _rule2:ScaleBitmapImage;
      
      private var _setsPropVec:Vector.<FilterFrameText>;
      
      private var _validity:Vector.<FilterFrameText>;
      
      private var _thisHeight:int;
      
      private var _thisWidht:int;
      
      private var _info:SuitTemplateInfo;
      
      private var _itemInfo:ItemTemplateInfo;
      
      private var _EquipInfo:InventoryItemInfo;
      
      private var _playerInfo:PlayerInfo;
      
      private var _suitId:int;
      
      private var _ContainEquip:Array;
      
      public function LaterEquipmentGoodView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      private function initData() : void
      {
         var _loc2_:Array = null;
         if(ItemManager.Instance.EquipSuit)
         {
            _loc2_ = ItemManager.Instance.EquipSuit[this._info.SuitId] as Array;
            if(_loc2_)
            {
               this.SUITNUM = _loc2_.length;
            }
         }
         this._setsPropVec = new Vector.<FilterFrameText>(this.SUITNUM);
         this._validity = new Vector.<FilterFrameText>(this.SUITNUM);
         var _loc1_:int = 0;
         while(_loc1_ < this.SUITNUM)
         {
            this._setsPropVec[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.setsPropText");
            this._validity[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.setsPropText");
            _loc1_++;
         }
      }
      
      private function showText() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.SUITNUM)
         {
            addChild(this._setsPropVec[_loc1_]);
            addChild(this._validity[_loc1_]);
            _loc1_++;
         }
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(param1)
         {
            this._itemInfo = param1 as ItemTemplateInfo;
            this.visible = true;
            _tipData = this._itemInfo;
            this._suitId = this._itemInfo.SuitId;
            if(this._suitId != 0)
            {
               this._info = ItemManager.Instance.getSuitTemplateByID(String(this._suitId));
               if(this._info)
               {
                  this.showTip();
               }
               else
               {
                  this.visible = false;
               }
            }
            else
            {
               this.visible = false;
            }
         }
         else
         {
            this.visible = false;
         }
      }
      
      public function showTip() : void
      {
         this.updateView();
      }
      
      private function updateView() : void
      {
         this.clear();
         this.initData();
         this.showText();
         this.showHeadPart();
         this.showMiddlePart();
         this.showButtomPart();
         this.upBackground();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._topName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.name");
         this._setNum = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.name");
         addChild(this._bg);
         addChild(this._rule1);
         addChild(this._rule2);
         addChild(this._topName);
         addChild(this._setNum);
      }
      
      private function showHeadPart() : void
      {
         this._topName.text = this._info.SuitName;
         if(!LaterEquipmentGoodView.isShow)
         {
            this._topName.textColor = 10066329;
         }
         this._rule1.x = this._topName.x;
         this._rule1.y = this._topName.y + this._topName.textHeight + 10;
         this._thisHeight = this._rule1.y + this._rule1.height;
         this._thisWidht = this._thisWidht > this._rule1.y + this._rule1.width ? int(int(this._thisWidht)) : int(int(this._rule1.y + this._rule1.width));
      }
      
      private function showMiddlePart() : void
      {
         var _loc6_:int = 0;
         var _loc1_:Array = null;
         _loc6_ = 0;
         var _loc7_:ItemTemplateInfo = null;
         var _loc8_:EquipSuitTemplateInfo = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         this._playerInfo = !!Boolean(ItemManager.Instance.playerInfo) ? ItemManager.Instance.playerInfo : PlayerManager.Instance.Self;
         this._ContainEquip = ItemManager.Instance.EquipSuit[this._info.SuitId] as Array;
         if(this._ContainEquip == null)
         {
            return;
         }
         _loc1_ = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < this._ContainEquip.length)
         {
            if(this._ContainEquip[_loc4_])
            {
               _loc7_ = ItemManager.Instance.getTemplateById(int(this._ContainEquip[_loc4_]));
               _loc1_.push(this._ContainEquip[_loc4_].PartName);
            }
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < EQUIPNUM)
         {
            this._EquipInfo = this._playerInfo.Bag.getItemAt(_loc5_);
            if(this._EquipInfo != null)
            {
               _loc3_.push(this._EquipInfo.TemplateID);
            }
            _loc5_++;
         }
         _loc6_ = 0;
         while(_loc6_ < this._setsPropVec.length)
         {
            if(_loc6_ < _loc1_.length)
            {
               this._setsPropVec[_loc6_].visible = true;
               this._setsPropVec[_loc6_].text = _loc1_[_loc6_];
               _loc8_ = ItemManager.Instance.getEquipSuitbyContainEquip(this._setsPropVec[_loc6_].text);
               _loc9_ = _loc8_.ContainEquip.split(",");
               _loc10_ = 0;
               while(_loc10_ < _loc3_.length)
               {
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_.length)
                  {
                     if(_loc9_[_loc11_] == _loc3_[_loc10_])
                     {
                        this._setsPropVec[_loc6_].textColor = 10092339;
                     }
                     this._setsPropVec[_loc6_].textColor = 10066329;
                     _loc11_++;
                  }
                  _loc10_++;
               }
               if(!LaterEquipmentGoodView.isShow)
               {
                  this._setsPropVec[_loc6_].textColor = 10066329;
               }
               if(!LaterEquipmentGoodView.isShow)
               {
                  this._setsPropVec[_loc6_].textColor = 10066329;
               }
               this._setsPropVec[_loc6_].y = this._rule1.y + this._rule1.height + 8 + 24 * _loc6_;
               if(_loc6_ == _loc1_.length - 1)
               {
                  this._rule2.x = this._setsPropVec[_loc6_].x;
                  this._rule2.y = this._setsPropVec[_loc6_].y + this._setsPropVec[_loc6_].textHeight + 12;
               }
            }
            else
            {
               this._setsPropVec[_loc6_].visible = false;
            }
            _loc6_++;
         }
         this._thisHeight = this._rule2.y + this._rule2.height;
      }
      
      private function showButtomPart() : void
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < EQUIPNUM)
         {
            this._EquipInfo = this._playerInfo.Bag.getItemAt(_loc3_);
            if(this._EquipInfo != null)
            {
               _loc2_.push(this._EquipInfo.TemplateID);
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._ContainEquip.length)
         {
            _loc6_ = this._ContainEquip[_loc4_].ContainEquip.split(",");
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc2_.length)
               {
                  if(_loc2_[_loc8_] == _loc6_[_loc7_])
                  {
                     _loc1_.push(_loc8_);
                  }
                  _loc8_++;
               }
               _loc7_++;
            }
            _loc4_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.SUITNUM)
         {
            if(this._info["SkillDescribe" + (_loc5_ + 1)] != "")
            {
               this._validity[_loc5_].visible = true;
               _loc9_ = int(this._info["EqipCount" + (_loc5_ + 1)]);
               if(_loc1_.length >= _loc9_)
               {
                  this._validity[_loc5_].text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.equip",_loc9_) + "\n    " + this._info["SkillDescribe" + (_loc5_ + 1)];
                  this._validity[_loc5_].textColor = QualityType.QUALITY_COLOR[2];
                  if(!LaterEquipmentGoodView.isShow)
                  {
                     this._validity[_loc5_].text = LanguageMgr.GetTranslation("ddt.goodTip.laterEquipmentGoodView.equip",_loc9_) + "\n    " + this._info["SkillDescribe" + (_loc5_ + 1)];
                     this._validity[_loc5_].textColor = 10066329;
                  }
               }
               else
               {
                  this._validity[_loc5_].text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.equip",_loc9_) + "\n    " + this._info["SkillDescribe" + (_loc5_ + 1)];
                  this._validity[_loc5_].textColor = 10066329;
                  if(!LaterEquipmentGoodView.isShow)
                  {
                     this._validity[_loc5_].text = LanguageMgr.GetTranslation("ddt.goodTip.laterEquipmentGoodView.equip",_loc9_) + "\n    " + this._info["SkillDescribe" + (_loc5_ + 1)];
                     this._validity[_loc5_].textColor = 10066329;
                  }
               }
            }
            else
            {
               this._validity[_loc5_].visible = false;
            }
            this._validity[_loc5_].y = this._thisHeight + 4;
            this._thisHeight = this._validity[_loc5_].y + this._validity[_loc5_].textHeight;
            this._thisWidht = this._thisWidht > this._validity[_loc5_].x + this._validity[_loc5_].textWidth ? int(int(this._thisWidht)) : int(int(this._validity[_loc5_].x + this._validity[_loc5_].textWidth));
            _loc5_++;
         }
         this._setNum.text = "(" + _loc1_.length + "/" + this._ContainEquip.length + ")";
         this._setNum.x = this._topName.textWidth + 12;
         this._setNum.y = this._topName.y;
      }
      
      private function upBackground() : void
      {
         this._bg.height = this._thisHeight + 13;
         this._bg.width = this._thisWidht + 13;
         this.updateWH();
      }
      
      private function updateWH() : void
      {
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      private function clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.SUITNUM = 0;
         if(this._setsPropVec && this._setsPropVec.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this._setsPropVec.length)
            {
               this._setsPropVec[_loc1_].dispose();
               this._setsPropVec[_loc1_] = null;
               _loc1_++;
            }
            this._setsPropVec = null;
         }
         if(this._validity && this._validity.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this._validity.length)
            {
               this._validity[_loc2_].dispose();
               this._validity[_loc2_] = null;
               _loc2_++;
            }
            this._validity = null;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._bg)
         {
            this._bg.dispose();
            this._bg = null;
         }
         if(this._rule1)
         {
            this._rule1.dispose();
            this._rule1 = null;
         }
         if(this._rule2)
         {
            this._rule2.dispose();
            this._rule2 = null;
         }
         if(this._topName)
         {
            this._topName.dispose();
            this._topName = null;
         }
         if(this._setNum)
         {
            this._setNum.dispose();
            this._setNum = null;
         }
         this.clear();
         ObjectUtils.disposeAllChildren(this);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
