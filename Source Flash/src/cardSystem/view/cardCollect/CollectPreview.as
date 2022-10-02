package cardSystem.view.cardCollect
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.data.SetsPropertyInfo;
   import cardSystem.elements.PreviewCard;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   
   public class CollectPreview extends Sprite implements Disposeable
   {
      
      public static const PREVIEWCARD_ALL_LENGTH:int = 350;
      
      public static const PREVIEWCARD_WIDHT:int = 66;
       
      
      private var _bg:Scale9CornerImage;
      
      private var _setsName:GradientText;
      
      private var _stroyBG:Bitmap;
      
      private var _stroy:FilterFrameText;
      
      private var _itemInfo:SetsInfo;
      
      private var _previewCardVec:Vector.<PreviewCard>;
      
      private var _setsPropBG:Scale9CornerImage;
      
      private var _propExplain:GradientText;
      
      private var _propDescript:TextArea;
      
      public function CollectPreview()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.BG");
         this._setsName = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.setsName");
         this._stroyBG = ComponentFactory.Instance.creatBitmap("asset.cardCollect.storyBG");
         this._stroy = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.story");
         this._setsPropBG = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.setsPropBG");
         this._propExplain = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.propExplain");
         this._propDescript = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.propArea");
         addChild(this._bg);
         addChild(this._setsName);
         addChild(this._stroyBG);
         addChild(this._stroy);
         addChild(this._setsPropBG);
         addChild(this._propExplain);
         addChild(this._propDescript);
         this._previewCardVec = new Vector.<PreviewCard>(5);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._previewCardVec[_loc1_] = new PreviewCard();
            addChild(this._previewCardVec[_loc1_]);
            this._previewCardVec[_loc1_].y = 148;
            _loc1_++;
         }
         this._propExplain.text = LanguageMgr.GetTranslation("ddt.cardSystem.preview.propExplain");
      }
      
      public function set info(param1:SetsInfo) : void
      {
         if(this._itemInfo == param1)
         {
            return;
         }
         this._itemInfo = param1;
         this.upView();
      }
      
      private function upView() : void
      {
         var _loc4_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Array = null;
         var _loc18_:String = null;
         var _loc1_:Vector.<CardInfo> = CardControl.Instance.model.getSetsCardFromCardBag(this._itemInfo.ID);
         this._setsName.text = this._itemInfo.name;
         this._setsName.x = this._bg.x + this._bg.width / 2 - this._setsName.textWidth / 2;
         this._stroy.text = "    " + this._itemInfo.storyDescript;
         var _loc2_:int = this._itemInfo.cardIdVec.length;
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            if(_loc3_ < _loc2_)
            {
               this._previewCardVec[_loc3_].cardId = this._itemInfo.cardIdVec[_loc3_];
               this._previewCardVec[_loc3_].visible = true;
               if(_loc1_.length > 0)
               {
                  _loc16_ = 0;
                  while(_loc16_ < _loc1_.length)
                  {
                     if(this._previewCardVec[_loc3_].cardId == _loc1_[_loc16_].TemplateID)
                     {
                        this._previewCardVec[_loc3_].cardInfo = _loc1_[_loc16_];
                        break;
                     }
                     if(_loc16_ == _loc1_.length - 1)
                     {
                        this._previewCardVec[_loc3_].cardInfo = null;
                     }
                     _loc16_++;
                  }
               }
               else
               {
                  this._previewCardVec[_loc3_].cardInfo = null;
               }
            }
            else
            {
               this._previewCardVec[_loc3_].visible = false;
            }
            _loc3_++;
         }
         _loc4_ = PREVIEWCARD_ALL_LENGTH / _loc2_;
         var _loc5_:int = 18 + _loc4_ / 2 - PREVIEWCARD_WIDHT / 2;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            this._previewCardVec[_loc6_].x = _loc5_;
            _loc5_ += _loc4_;
            _loc6_++;
         }
         var _loc7_:Vector.<SetsPropertyInfo> = CardControl.Instance.model.setsList[this._itemInfo.ID];
         var _loc8_:int = _loc7_.length;
         var _loc9_:String = "";
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_)
         {
            _loc17_ = _loc7_[_loc10_].value.split("|");
            if(_loc17_.length == 4)
            {
               _loc18_ = _loc17_[0] + "/" + _loc17_[1] + "/" + _loc17_[2] + "/" + _loc17_[3] + LanguageMgr.GetTranslation("cardSystem.preview.descript.level");
               _loc9_ = _loc9_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp1") + _loc7_[_loc10_].condition + LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp2") + " " + _loc7_[_loc10_].Description.replace("{0}",_loc18_));
            }
            else
            {
               _loc9_ = _loc9_.concat(LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp1") + _loc7_[_loc10_].condition + LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp2") + " " + _loc7_[_loc10_].Description.replace("{0}",_loc17_[0]));
            }
            _loc9_ = _loc9_.concat("\n\n");
            _loc10_++;
         }
         this._propDescript.text = _loc9_;
         var _loc11_:TextFormat = new TextFormat();
         _loc11_.bold = true;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:String = LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp1");
         var _loc15_:String = LanguageMgr.GetTranslation("ddt.cardSystem.preview.setProp2");
         while(_loc9_.indexOf(_loc14_) > -1)
         {
            if(_loc12_ != 0)
            {
               _loc13_ += _loc14_.length + _loc15_.length + 1 + _loc9_.indexOf(_loc14_);
            }
            this._propDescript.textField.setTextFormat(_loc11_,_loc13_,_loc13_ + _loc14_.length + _loc15_.length + 2);
            _loc9_ = _loc9_.substr(_loc9_.indexOf(_loc15_) + _loc15_.length + 1,_loc9_.length);
            _loc12_++;
         }
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._itemInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._setsName = null;
         this._stroyBG = null;
         this._stroy = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._previewCardVec.length)
         {
            this._previewCardVec[_loc1_] = null;
            _loc1_++;
         }
         this._previewCardVec = null;
         this._setsPropBG = null;
         this._propExplain = null;
         this._propDescript = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
