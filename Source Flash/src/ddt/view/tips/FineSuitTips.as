package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.store.FineSuitVo;
   import ddt.manager.FineSuitManager;
   import ddt.manager.LanguageMgr;
   
   public class FineSuitTips extends BaseTip
   {
      private var _title:FilterFrameText;
      
      private var suitType:Array;
      
      private var _itemList:Vector.<FineSuitTipsItem>;
      
      private var _textList:Vector.<FilterFrameText>;
      
      private var _line1:Image;
      
      private var _line2:Image;
      
      public function FineSuitTips()
      {
         this.suitType = LanguageMgr.GetTranslation("storeFine.suit.type").split(",");
         super();
      }
      
      override protected function init() : void
      {
         tipbackgound = ComponentFactory.Instance.creat("core.GoodsTipBg");
      }
      
      override protected function addChildren() : void
      {
         var _loc1_:FineSuitTipsItem = null;
         var _loc2_:FilterFrameText = null;
         super.addChildren();
         ObjectUtils.copyPropertyByRectangle(_tipbackgound,ComponentFactory.Instance.creatCustomObject("ddtstore.tips.bgRect"));
         this._title = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.title");
         this._title.text = LanguageMgr.GetTranslation("storeFine.tips.titleText");
         addChild(this._title);
         this._line1 = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.line");
         addChild(this._line1);
         this._line2 = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.line");
         addChild(this._line2);
         this._itemList = new Vector.<FineSuitTipsItem>();
         this._textList = new Vector.<FilterFrameText>();
         var _loc3_:int = 0;
         while(_loc3_ < 12)
         {
            if(_loc3_ < 5)
            {
               _loc1_ = new FineSuitTipsItem();
               this._itemList.push(_loc1_);
               addChild(_loc1_);
            }
            else
            {
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.itemUnfold");
               this._textList.push(_loc2_);
               addChild(_loc2_);
            }
            _loc3_++;
         }
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(_tipData == param1)
         {
            return;
         }
         _tipData = param1;
         this.updateTipsView();
      }
      
      private function updateTipsView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FineSuitTipsItem = null;
         var _loc7_:int = 0;
         _loc1_ = 0;
         _loc2_ = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:FilterFrameText = null;
         var _loc6_:FineSuitVo = FineSuitManager.Instance.getSuitVoByExp(int(_tipData));
         _loc7_ = _loc6_.type == 0 ? int(int(1)) : int(int(_loc6_.type));
         var _loc8_:int = _loc6_.level;
         if(_loc8_ > 14)
         {
            _loc8_ = _loc8_ == 0 ? int(int(0)) : (_loc8_ % 14 == 0 ? int(int(14)) : int(int(_loc8_ % 14)));
         }
         _loc1_ = 43;
         _tipbackgound.width = 100;
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            _loc2_ = this._itemList[_loc3_];
            _loc2_.titleText = LanguageMgr.GetTranslation("storeFine.tips.itemText",this.suitType[_loc3_]);
            _loc2_.text = FineSuitManager.Instance.getTipsPropertyInfoListToString(_loc3_ + 1,"all");
            _loc2_.type = _loc3_ + 1;
            _loc2_.complete = _loc3_ + 1 < _loc7_ || _loc3_ == 4 && _loc6_.level == 70;
            _loc2_.y = _loc1_;
            _loc1_ += _loc2_.height;
            this.setBackgoundWidth(_loc2_.width);
            if(_loc3_ + 1 == _loc7_)
            {
               this._line1.y = _loc1_;
               _loc1_ += 10;
               _loc4_ = 0;
               while(_loc4_ < 7)
               {
                  _loc5_ = this._textList[_loc4_];
                  _loc5_.text = this.getItmeContent(_loc4_ + 1,_loc7_);
                  _loc5_.setFrame(_loc8_ >= (_loc4_ + 1) * 2 ? int(int(1)) : int(int(2)));
                  _loc5_.y = _loc1_;
                  _loc1_ += _loc5_.height;
                  this.setBackgoundWidth(_loc5_.width);
                  _loc4_++;
               }
               this._line2.y = _loc1_ + 10;
               _loc1_ += 20;
            }
            _loc3_++;
         }
         _tipbackgound.height = _loc1_;
      }
      
      private function getItmeContent(param1:int, param2:int) : String
      {
         var _loc3_:String = (param1 * 2).toString();
         return "[" + this.suitType[param2 - 1] + "]" + "(" + _loc3_ + "/14) " + FineSuitManager.Instance.getTipsPropertyInfoListToString(param2,_loc3_);
      }
      
      private function setBackgoundWidth(param1:int) : void
      {
         if(param1 + 20 > _tipbackgound.width)
         {
            _tipbackgound.width = param1 + 20;
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._itemList = null;
         this._textList = null;
         super.dispose();
      }
   }
}
