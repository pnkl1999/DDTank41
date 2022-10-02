package equipretrieve
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import equipretrieve.view.RetrieveBagFrame;
   import equipretrieve.view.RetrieveBagView;
   import equipretrieve.view.RetrieveBagcell;
   import equipretrieve.view.RetrieveBgView;
   import flash.utils.Dictionary;
   
   public class RetrieveFrame extends Frame
   {
       
      
      private var _retrieveBgView:RetrieveBgView;
      
      private var _retrieveBagView:RetrieveBagFrame;
      
      private var _alertInfo:AlertInfo;
      
      private var _BG:Scale9CornerImage;
      
      public function RetrieveFrame()
      {
         super();
         this.start();
      }
      
      private function start() : void
      {
         this.escEnable = true;
         this._BG = ComponentFactory.Instance.creatComponentByStylename("trieveFrame.bg");
         addToContent(this._BG);
         this._retrieveBgView = ComponentFactory.Instance.creatCustomObject("retrieve.retrieveBgView");
         this._retrieveBagView = ComponentFactory.Instance.creatCustomObject("retrieve.retrieveBagView");
         addToContent(this._retrieveBagView);
         addToContent(this._retrieveBgView);
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function updateBag(param1:Dictionary) : void
      {
         this._retrieveBgView.refreshData(param1);
      }
      
      public function cellDoubleClick(param1:RetrieveBagcell) : void
      {
         this._retrieveBgView.cellDoubleClick(param1);
      }
      
      public function set bagType(param1:int) : void
      {
         RetrieveBagView(this._retrieveBagView.bagView).resultPoint(param1,this._retrieveBagView.x - this._retrieveBgView.x,this._retrieveBagView.y - this._retrieveBgView.y);
      }
      
      public function set shine(param1:Boolean) : void
      {
         if(param1 == true)
         {
            this._retrieveBgView.startShine();
         }
         else
         {
            this._retrieveBgView.stopShine();
         }
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(!RetrieveController.Instance.viewMouseEvtBoolean)
         {
            return;
         }
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || RetrieveController.Instance.viewMouseEvtBoolean)
         {
            RetrieveController.Instance.close();
         }
      }
      
      override public function dispose() : void
      {
         if(this._retrieveBagView)
         {
            this._retrieveBagView.bagView.setBagType(0);
         }
         disposeChildren = true;
         if(this._retrieveBgView)
         {
            ObjectUtils.disposeObject(this._retrieveBgView);
         }
         this._retrieveBgView = null;
         if(this._retrieveBagView)
         {
            ObjectUtils.disposeObject(this._retrieveBagView);
         }
         this._retrieveBagView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
