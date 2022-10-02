package giftSystem.view.giftAndRecord
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import giftSystem.data.MyGiftCellInfo;
   import giftSystem.element.MyGiftItem;
   
   public class MyGiftView extends Sprite implements Disposeable
   {
       
      
      private var _BG:Scale9CornerImage;
      
      private var _myGiftItemContainerAll:VBox;
      
      private var _myGiftItemContainers:Vector.<HBox>;
      
      private var _panel:ScrollPanel;
      
      private var _count:int = 0;
      
      private var _line:int = 0;
      
      private var _itemArr:Vector.<MyGiftItem>;
      
      public function MyGiftView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._myGiftItemContainers = new Vector.<HBox>();
         this._itemArr = new Vector.<MyGiftItem>();
         this._BG = ComponentFactory.Instance.creatComponentByStylename("MyGiftView.BG");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("MyGiftView.myGiftItemPanel");
         this._myGiftItemContainerAll = ComponentFactory.Instance.creatComponentByStylename("MyGiftView.myGiftItemContainerAll");
         this._panel.setView(this._myGiftItemContainerAll);
         addChild(this._BG);
         addChild(this._panel);
      }
      
      public function setList(param1:Vector.<MyGiftCellInfo>) : void
      {
         this.clearList();
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.addItem(param1[_loc3_]);
            _loc3_++;
         }
      }
      
      public function addItem(param1:MyGiftCellInfo) : void
      {
         if(this._count % 3 == 0)
         {
            this._line = this._count / 3;
            this._myGiftItemContainers[this._line] = ComponentFactory.Instance.creatComponentByStylename("MyGiftView.myGiftItemContainer");
            this._myGiftItemContainerAll.addChild(this._myGiftItemContainers[this._line]);
         }
         var _loc2_:MyGiftItem = new MyGiftItem();
         _loc2_.info = param1;
         this._myGiftItemContainers[this._line].addChild(_loc2_);
         this._itemArr.push(_loc2_);
         ++this._count;
         this._myGiftItemContainerAll.height = _loc2_.height * (this._line + 1);
         this._panel.invalidateViewport();
      }
      
      public function upItem(param1:MyGiftCellInfo) : void
      {
         var _loc2_:int = this._itemArr.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._itemArr[_loc3_].info.TemplateID == param1.TemplateID)
            {
               this._itemArr[_loc3_].info = param1;
               break;
            }
            _loc3_++;
         }
      }
      
      private function clearList() : void
      {
         ObjectUtils.disposeAllChildren(this._myGiftItemContainerAll);
         var _loc1_:int = 0;
         while(_loc1_ < this._line + 1)
         {
            this._myGiftItemContainers[_loc1_] = null;
            _loc1_++;
         }
         this._myGiftItemContainers = new Vector.<HBox>();
         this._itemArr = null;
         this._itemArr = new Vector.<MyGiftItem>();
         this._count = 0;
         this._line = 0;
         this._panel.invalidateViewport();
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
         ObjectUtils.disposeAllChildren(this);
         this._BG = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._line + 1)
         {
            this._myGiftItemContainers[_loc1_] = null;
            _loc1_++;
         }
         this._myGiftItemContainerAll = null;
         this._panel = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
