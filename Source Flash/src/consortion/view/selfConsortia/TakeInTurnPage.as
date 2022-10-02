package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TakeInTurnPage extends Sprite implements Disposeable
   {
      
      public static const PAGE_CHANGE:String = "pageChange";
       
      
      private var _bg:Bitmap;
      
      private var _next:BaseButton;
      
      private var _pre:BaseButton;
      
      private var _page:FilterFrameText;
      
      private var _present:int = 1;
      
      private var _sum:int = 1;
      
      public function TakeInTurnPage()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get present() : int
      {
         return this._present;
      }
      
      public function set present(param1:int) : void
      {
         this._present = param1;
         this.setPage();
      }
      
      public function get sum() : int
      {
         return this._sum;
      }
      
      public function set sum(param1:int) : void
      {
         this._sum = param1 < 1 ? int(int(1)) : int(int(param1));
         this.setPage();
         this.setBtnState();
      }
      
      private function setPage() : void
      {
         this._page.text = this._present + "/" + this._sum;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortion.takeIn.pageBg");
         this._next = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.turnPage.next");
         this._pre = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.turnPage.pre");
         this._page = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.turnPage.page");
         addChild(this._bg);
         addChild(this._next);
         addChild(this._pre);
         addChild(this._page);
      }
      
      private function initEvent() : void
      {
         this._next.addEventListener(MouseEvent.CLICK,this.__nextHanlder);
         this._pre.addEventListener(MouseEvent.CLICK,this.__preHanlder);
      }
      
      private function removeEvent() : void
      {
         this._next.removeEventListener(MouseEvent.CLICK,this.__nextHanlder);
         this._pre.removeEventListener(MouseEvent.CLICK,this.__preHanlder);
      }
      
      private function __nextHanlder(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this.present;
         if(this._present > this._sum)
         {
            this.present = this.sum;
         }
         else
         {
            dispatchEvent(new Event(PAGE_CHANGE));
         }
         this.setBtnState();
      }
      
      private function setBtnState() : void
      {
         if(this.present == 1)
         {
            this._pre.enable = false;
            this._pre.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._pre.enable = true;
            this._pre.filters = null;
         }
         if(this.present == this.sum)
         {
            this._next.enable = false;
            this._next.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._next.enable = true;
            this._next.filters = null;
         }
      }
      
      private function __preHanlder(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         --this.present;
         if(this._present < 1)
         {
            this.present = 1;
         }
         else
         {
            dispatchEvent(new Event(PAGE_CHANGE));
         }
         this.setBtnState();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._next = null;
         this._pre = null;
         this._page = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
