package ddt.view.bossbox
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class VipInfoTipBox extends Frame
   {
       
      
      private var _goodsList:Array;
      
      private var _list:VipInfoTipList;
      
      private var _button:BaseButton;
      
      private var _buttonLight:MovieImage;
      
      private var _goodsBG:Scale9CornerImage;
      
      private var _titleBG:Image;
      
      private var _txtGetAwardsByLV:FilterFrameText;
      
      private var _selectCellInfo:ItemTemplateInfo;
      
      public function VipInfoTipBox()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get selectCellInfo() : ItemTemplateInfo
      {
         return this._selectCellInfo;
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
         this._goodsBG = ComponentFactory.Instance.creat("bossbox.scale9GoodsImageIII");
         addToContent(this._goodsBG);
         this._titleBG = ComponentFactory.Instance.creat("bossbox.VipBoxTipBg");
         addToContent(this._titleBG);
         this._txtGetAwardsByLV = ComponentFactory.Instance.creat("Vip.GetAwardsByLV");
         addToContent(this._txtGetAwardsByLV);
         this._txtGetAwardsByLV.text = LanguageMgr.GetTranslation("ddt.vip.vipView.getAwardsByLVText");
         this._button = ComponentFactory.Instance.creat("Vip.GetAwardsByLVBtn");
         this._buttonLight = ComponentFactory.Instance.creat("bossbox.BoxGetBlik.vip");
         this._buttonLight.x = this._button.x;
         this._buttonLight.y = this._button.y;
         this._buttonLight.mouseEnabled = false;
         this._buttonLight.mouseChildren = false;
         addToContent(this._button);
         addToContent(this._buttonLight);
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._button.enable = false;
            this._buttonLight.visible = false;
         }
      }
      
      public function set vipAwardGoodsList(param1:Array) : void
      {
         this._goodsList = param1;
         this._list = ComponentFactory.Instance.creatCustomObject("bossbox.VipInfoTipList");
         this._list.showForVipAward(this._goodsList);
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._button.addEventListener(MouseEvent.CLICK,this._click);
      }
      
      private function _click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectCellInfo = this._list.currentCell.info;
         dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(this._button)
         {
            this._button.removeEventListener(MouseEvent.CLICK,this._click);
            ObjectUtils.disposeObject(this._button);
            this._button = null;
         }
         ObjectUtils.disposeObject(this._titleBG);
         this._titleBG = null;
         if(this._txtGetAwardsByLV)
         {
            ObjectUtils.disposeObject(this._txtGetAwardsByLV);
            this._txtGetAwardsByLV = null;
         }
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
