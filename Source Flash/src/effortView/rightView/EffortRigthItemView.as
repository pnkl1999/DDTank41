package effortView.rightView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortQualificationInfo;
   import ddt.data.effort.EffortRewardInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import effortView.completeIcon.EffortCompleteIconView;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import road7th.data.DictionaryData;
   
   public class EffortRigthItemView extends Sprite implements Disposeable, IListCell
   {
      
      public static const EFFORT_ICON_POS:int = 5;
      
      public static const SCALESTRIP_POS_OFSET:int = 10;
      
      public static const MAX_HEIGHT:int = 110;
      
      public static const MIN_HEIGHT:int = 90;
      
      public static const BG03_MAX_HEIGHT_OFSET:int = 3;
      
      public static const HONOR_POS_OFSET:int = 3;
       
      
      protected var _info:EffortInfo;
      
      protected var _completeNextEffortArray:Array;
      
      protected var _isSelect:Boolean;
      
      protected var _scaleStrip:EffortScaleStrip;
      
      protected var _bg_01:ScaleBitmapImage;
      
      protected var _bg_02:ScaleBitmapImage;
      
      protected var _bg_03:ScaleBitmapImage;
      
      protected var _effortIcon:EffortIconView;
      
      protected var _maxHeight:int;
      
      protected var _minHeight:int;
      
      protected var _achievementPointView:AchievementPointView;
      
      protected var _title:FilterFrameText;
      
      protected var _titleII:FilterFrameText;
      
      protected var _detail:FilterFrameText;
      
      protected var _detailII:FilterFrameText;
      
      protected var _honor:TextField;
      
      protected var _honorII:TextField;
      
      protected var _date:FilterFrameText;
      
      protected var _iconContent:HBox;
      
      protected var _iconArray:Array;
      
      public function EffortRigthItemView()
      {
         super();
         this.init();
         this.initText();
         this.initEvent();
      }
      
      protected function init() : void
      {
         var _loc3_:EffortCompleteIconView = null;
         var _loc1_:Point = null;
         _loc3_ = null;
         this._bg_01 = ComponentFactory.Instance.creat("effortView.EffortRigthItemView.rightItemBg_01");
         addChild(this._bg_01);
         this._effortIcon = new EffortIconView();
         this._effortIcon.x = EFFORT_ICON_POS;
         this._effortIcon.y = EFFORT_ICON_POS;
         addChild(this._effortIcon);
         this._achievementPointView = new AchievementPointView();
         _loc1_ = ComponentFactory.Instance.creatCustomObject("effortView.EffortRigthItemView.achievementPointViewPos");
         this._achievementPointView.x = _loc1_.x;
         this._achievementPointView.y = _loc1_.y;
         addChild(this._achievementPointView);
         this._bg_02 = ComponentFactory.Instance.creat("effortView.EffortRigthItemView.rightItemBg_02");
         addChild(this._bg_02);
         this._bg_03 = ComponentFactory.Instance.creat("effortView.EffortRigthItemView.rightItemBg_03");
         addChild(this._bg_03);
         this._scaleStrip = new EffortScaleStrip(0);
         this._scaleStrip.setButtonMode(false);
         this._scaleStrip.x = this._bg_01.width / 2 - this._scaleStrip.width / 2 + SCALESTRIP_POS_OFSET;
         this._scaleStrip.y = this._bg_01.height - this._scaleStrip.height + SCALESTRIP_POS_OFSET + 6;
         this._scaleStrip.visible = false;
         addChild(this._scaleStrip);
         this.buttonMode = true;
         this._iconContent = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconView.iconHBox");
         addChild(this._iconContent);
         this._iconArray = [];
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = new EffortCompleteIconView();
            _loc3_.visible = false;
            this._iconArray.push(_loc3_);
            this._iconContent.addChild(_loc3_);
            _loc2_++;
         }
      }
      
      protected function updateScaleStrip() : void
      {
         var _loc2_:EffortQualificationInfo = null;
         if(!this._info.CanHide || this._info.CompleteStateInfo || !EffortManager.Instance.isSelf)
         {
            this._scaleStrip.visible = false;
            return;
         }
         if(this._info.EffortQualificationList.length > 1)
         {
            return;
         }
         var _loc1_:int = 0;
         for each(_loc2_ in this._info.EffortQualificationList)
         {
            _loc1_ = _loc2_.Condiction_Para2;
         }
         this._scaleStrip.setInfo(_loc1_);
         this._scaleStrip.currentVlaue = this.getQualificationValue(this._info.EffortQualificationList);
      }
      
      protected function initMaxHeight() : void
      {
         if(EffortManager.Instance.isSelf)
         {
            if(this._info && this._info.CompleteStateInfo && this._info.IsOther)
            {
               this._info.maxHeight = MAX_HEIGHT;
            }
            else if(this._info)
            {
               this._info.maxHeight = MIN_HEIGHT;
            }
         }
         else if(this._info && EffortManager.Instance.tempEffortIsComplete(this._info.ID) && this._info.IsOther)
         {
            this._info.maxHeight = MAX_HEIGHT;
         }
         else if(this._info)
         {
            this._info.maxHeight = MIN_HEIGHT;
         }
      }
      
      protected function initText() : void
      {
         this._title = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortRigthItemView.EffortRigthItemText_01");
         addChild(this._title);
         this._titleII = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortRigthItemView.EffortRigthItemText_02");
         addChild(this._titleII);
         this._detail = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortRigthItemView.EffortRigthItemText_03");
         addChild(this._detail);
         this._detailII = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortRigthItemView.EffortRigthItemText_04");
         addChild(this._detailII);
         this._honor = ComponentFactory.Instance.creatCustomObject("EffortRigthItemView.EffortRigthItemText_05I");
         this._honor.defaultTextFormat = ComponentFactory.Instance.model.getSet("EffortRightItemTextTF_01");
         addChild(this._honor);
         this._honorII = ComponentFactory.Instance.creatCustomObject("EffortRigthItemView.EffortRigthItemText_06I");
         this._honorII.defaultTextFormat = ComponentFactory.Instance.model.getSet("EffortRightItemTextTF_02");
         addChild(this._honorII);
         this._honor.styleSheet = this._honorII.styleSheet = ChatFormats.styleSheet;
         this._honor.filters = this._honorII.filters = [ComponentFactory.Instance.model.getSet("GF_7")];
         this._honor.selectable = this._honorII.selectable = false;
         this._date = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortRigthItemView.EffortRigthItemText_07");
         addChild(this._date);
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__rigthItemOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__rigthItemOut);
         this._honor.addEventListener(TextEvent.LINK,this.__onTextClicked);
         this._honorII.addEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      protected function __rigthItemOut(param1:Event) : void
      {
         if(!this._info.isSelect)
         {
            this.setSelectState(true);
            this._bg_03.visible = false;
         }
      }
      
      protected function __rigthItemOver(param1:Event) : void
      {
         this.setSelectState(false);
         this._bg_03.visible = true;
      }
      
      private function __onTextClicked(param1:TextEvent) : void
      {
         var _loc4_:Point = null;
         var _loc6_:Array = null;
         var _loc7_:ItemTemplateInfo = null;
         SoundManager.instance.play("008");
         var _loc2_:Object = {};
         var _loc3_:Array = param1.text.split("|");
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_].indexOf(":"))
            {
               _loc6_ = _loc3_[_loc5_].split(":");
               _loc2_[_loc6_[0]] = _loc6_[1];
            }
            _loc5_++;
         }
         if(int(_loc2_.clicktype) == ChatFormats.CLICK_GOODS)
         {
            _loc4_ = this._honor.localToGlobal(new Point(this._honor.mouseX,this._honor.mouseY));
            _loc7_ = ItemManager.Instance.getTemplateById(_loc2_.templeteIDorItemID);
            _loc7_.BindType = _loc2_.isBind == "true" ? int(int(0)) : int(int(1));
            this._showLinkGoodsInfo(_loc7_,_loc4_);
         }
      }
      
      private function _showLinkGoodsInfo(param1:ItemTemplateInfo, param2:Point) : void
      {
         var _loc3_:CaddyEvent = new CaddyEvent(EffortRightHonorView.GOODSCLICK);
         _loc3_.itemTemplateInfo = param1;
         _loc3_.point = param2;
         dispatchEvent(_loc3_);
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__rigthItemOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__rigthItemOut);
         this._honor.removeEventListener(TextEvent.LINK,this.__onTextClicked);
         this._honorII.removeEventListener(TextEvent.LINK,this.__onTextClicked);
         if(this._scaleStrip)
         {
            this._scaleStrip.dispose();
         }
         this._scaleStrip = null;
         if(this._bg_01)
         {
            this._bg_01.dispose();
         }
         this._bg_01 = null;
         if(this._bg_02)
         {
            this._bg_02.dispose();
         }
         this._bg_02 = null;
         if(this._bg_03)
         {
            this._bg_03.dispose();
         }
         this._bg_03 = null;
         if(this._effortIcon)
         {
            this._effortIcon.dispose();
         }
         this._effortIcon = null;
         if(this._achievementPointView)
         {
            this._achievementPointView.dispose();
         }
         this._achievementPointView = null;
         if(this._title)
         {
            this._title.dispose();
         }
         this._title = null;
         if(this._titleII)
         {
            this._titleII.dispose();
         }
         this._titleII = null;
         if(this._detail)
         {
            this._detail.dispose();
         }
         this._detail = null;
         if(this._detailII)
         {
            this._detailII.dispose();
         }
         this._detailII = null;
         if(this._honor)
         {
            ObjectUtils.disposeObject(this._honor);
         }
         this._honor = null;
         if(this._honorII)
         {
            ObjectUtils.disposeObject(this._honorII);
         }
         this._honorII = null;
         if(this._date)
         {
            this._date.dispose();
         }
         this._date = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      protected function updateSize() : void
      {
         if(this._info.isSelect)
         {
            this._bg_01.height = this._info.maxHeight;
            this._bg_02.height = this._info.maxHeight;
            this._bg_03.height = this._info.maxHeight - BG03_MAX_HEIGHT_OFSET;
         }
         else
         {
            this._bg_01.height = this._info.minHeight;
            this._bg_02.height = this._info.minHeight;
            this._bg_03.height = this._info.minHeight - BG03_MAX_HEIGHT_OFSET;
         }
         this.updateDisplayObjectPos();
      }
      
      protected function update() : void
      {
         this.initMaxHeight();
         this.updateSelectState();
         this.updateComponent();
         this.updateDisplayObjectPos();
         this.updateCompleteNextEffortIcon();
      }
      
      protected function updateCompleteNextEffortIcon() : void
      {
         if(EffortManager.Instance.isSelf)
         {
            this.updateSelfCompleteNextEffortIcon();
         }
         else
         {
            this.updateOtherCompleteNextEffortIcon();
         }
         this._iconContent.y = this._bg_01.x + this._bg_01.height - this._iconContent.height - 8;
      }
      
      private function updateSelfCompleteNextEffortIcon() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._info.isSelect)
         {
            _loc1_ = 0;
            while(_loc1_ < 5)
            {
               (this._iconArray[_loc1_] as EffortCompleteIconView).visible = false;
               _loc1_++;
            }
            if(!this._info.IsOther)
            {
               return;
            }
            this._completeNextEffortArray = [];
            this._completeNextEffortArray = EffortManager.Instance.getCompleteNextEffort(EffortManager.Instance.getTopEffort(this._info));
            if(!this._completeNextEffortArray[0])
            {
               return;
            }
            _loc2_ = 0;
            while(_loc2_ < this._completeNextEffortArray.length)
            {
               (this._iconArray[_loc2_] as EffortCompleteIconView).setInfo(this._completeNextEffortArray[_loc2_]);
               (this._iconArray[_loc2_] as EffortCompleteIconView).visible = true;
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 5)
            {
               (this._iconArray[_loc3_] as EffortCompleteIconView).visible = false;
               _loc3_++;
            }
         }
      }
      
      private function updateOtherCompleteNextEffortIcon() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._info.isSelect)
         {
            _loc1_ = 0;
            while(_loc1_ < 5)
            {
               (this._iconArray[_loc1_] as EffortCompleteIconView).visible = false;
               _loc1_++;
            }
            if(!this._info.IsOther)
            {
               return;
            }
            this._completeNextEffortArray = [];
            this._completeNextEffortArray = EffortManager.Instance.getTempCompleteNextEffort(EffortManager.Instance.getTempTopEffort(this._info));
            if(!this._completeNextEffortArray[0])
            {
               return;
            }
            _loc2_ = 0;
            while(_loc2_ < this._completeNextEffortArray.length)
            {
               (this._iconArray[_loc2_] as EffortCompleteIconView).setInfo(this._completeNextEffortArray[_loc2_]);
               (this._iconArray[_loc2_] as EffortCompleteIconView).visible = true;
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 5)
            {
               (this._iconArray[_loc3_] as EffortCompleteIconView).visible = false;
               _loc3_++;
            }
         }
      }
      
      protected function updateComponent() : void
      {
         this._title.text = this._titleII.text = EffortManager.Instance.splitTitle(this._info.Title);
         this._detail.text = this._detailII.text = this._info.Detail;
         var _loc1_:Date = new Date();
         if(this._info.CompleteStateInfo)
         {
            _loc1_ = this._info.CompleteStateInfo.CompletedDate;
         }
         if(this._info.CompleteStateInfo && EffortManager.Instance.isSelf)
         {
            this._date.text = String(_loc1_.fullYear) + "/" + String(_loc1_.month + 1) + "/" + String(_loc1_.date);
         }
         else
         {
            this._date.text = "";
         }
         this._effortIcon.iconUrl = String(this._info.picId);
         this._achievementPointView.value = this._info.AchievementPoint;
         this.updateScaleStrip();
      }
      
      protected function updateSelectState() : void
      {
         if(this._info.isSelect)
         {
            this.setSelectState(false);
            this._bg_01.height = this._info.maxHeight;
            this._bg_02.height = this._info.maxHeight;
            this._bg_03.height = this._info.maxHeight - BG03_MAX_HEIGHT_OFSET;
            if(this._scaleStrip && this._info.CanHide && !this._info.CompleteStateInfo && EffortManager.Instance.isSelf)
            {
               this._scaleStrip.visible = true;
            }
            this._bg_03.visible = true;
         }
         else
         {
            this.setSelectState(true);
            this._bg_01.height = this._info.minHeight;
            this._bg_02.height = this._info.minHeight;
            this._bg_03.height = this._info.minHeight - BG03_MAX_HEIGHT_OFSET;
            if(this._scaleStrip && this._info.CanHide && EffortManager.Instance.isSelf)
            {
               this._scaleStrip.visible = false;
            }
            this._bg_03.visible = false;
         }
      }
      
      protected function updateDisplayObjectPos() : void
      {
         if(this._scaleStrip)
         {
            if(this._honor.text == "")
            {
               this._scaleStrip.y = this._bg_01.height - this._scaleStrip.height + HONOR_POS_OFSET;
            }
            else
            {
               this._scaleStrip.y = this._bg_01.height - this._scaleStrip.height - this._honor.height + SCALESTRIP_POS_OFSET + 6;
               this._honor.y = this._bg_01.height - this._honor.height - HONOR_POS_OFSET;
               this._honorII.y = this._honor.y;
            }
         }
      }
      
      protected function honorName() : void
      {
         var _loc1_:ChatData = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:String = null;
         if(this._info && this._info.effortRewardArray)
         {
            _loc1_ = new ChatData();
            _loc2_ = 0;
            while(_loc2_ < this._info.effortRewardArray.length)
            {
               if((this._info.effortRewardArray[_loc2_] as EffortRewardInfo).RewardType == 1)
               {
                  _loc1_.htmlMessage = LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorName") + EffortManager.Instance.splitTitle((this._info.effortRewardArray[_loc2_] as EffortRewardInfo).RewardPara) + LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameII");
               }
               else if((this._info.effortRewardArray[_loc2_] as EffortRewardInfo).RewardType == 3)
               {
                  _loc1_.htmlMessage += LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameIII");
                  _loc4_ = int(EffortManager.Instance.splitTitle((this._info.effortRewardArray[_loc2_] as EffortRewardInfo).RewardPara));
                  _loc5_ = ItemManager.Instance.getTemplateById(_loc4_);
                  _loc6_ = ChatFormats.creatGoodTag("[" + _loc5_.Name + "]",ChatFormats.CLICK_GOODS,_loc5_.TemplateID,_loc5_.Quality,true,_loc1_);
                  _loc1_.htmlMessage += _loc6_;
               }
               _loc2_++;
            }
            _loc3_ = "";
            _loc3_ += Helpers.deCodeString(_loc1_.htmlMessage);
            this._honor.htmlText = "<a>" + _loc3_ + "</a>";
            this._honorII.htmlText = "<a>" + _loc3_ + "</a>";
         }
         else
         {
            this._honor.text = "";
            this._honorII.text = "";
            this._honor.visible = true;
            this._honor.visible = true;
         }
      }
      
      protected function getQualificationValue(param1:DictionaryData) : int
      {
         var _loc2_:EffortQualificationInfo = null;
         var _loc3_:int = 0;
         var _loc4_:* = param1;
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.Condiction_Para2 > _loc2_.para2_currentValue)
            {
               return _loc2_.para2_currentValue;
            }
            return _loc2_.Condiction_Para2;
         }
         return 0;
      }
      
      protected function setSelectState(param1:Boolean) : void
      {
         if(EffortManager.Instance.isSelf)
         {
            if(param1)
            {
               if(!this._info.CompleteStateInfo)
               {
                  this.setTextVisible(false);
                  this._bg_02.visible = true;
               }
               else
               {
                  this.setTextVisible(true);
                  this._bg_02.visible = false;
               }
            }
            else if(!this._info.CompleteStateInfo)
            {
               this.setTextVisible(false);
               this._bg_02.visible = true;
            }
            else
            {
               this.setTextVisible(true);
               this._bg_02.visible = false;
            }
         }
         else if(param1)
         {
            if(!EffortManager.Instance.tempEffortIsComplete(this._info.ID))
            {
               this.setTextVisible(false);
               this._bg_02.visible = true;
            }
            else
            {
               this.setTextVisible(true);
               this._bg_02.visible = false;
            }
         }
         else if(!EffortManager.Instance.tempEffortIsComplete(this._info.ID))
         {
            this.setTextVisible(false);
            this._bg_02.visible = true;
         }
         else
         {
            this.setTextVisible(true);
            this._bg_02.visible = false;
         }
      }
      
      protected function setTextVisible(param1:Boolean) : void
      {
         this._title.visible = param1;
         this._detail.visible = param1;
         this._honor.visible = param1;
         this._titleII.visible = !param1;
         this._detailII.visible = !param1;
         this._honorII.visible = !param1;
         if(this._honor.htmlText == "")
         {
            this._honor.visible = false;
         }
         if(this._honorII.htmlText == "")
         {
            this._honorII.visible = false;
         }
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
