package ddt.view.caddyII.reader
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.geom.Point;
   
   public class CaddyReadAwardsView extends ReadAwardsView
   {
       
      
      public function CaddyReadAwardsView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         _bg2 = ComponentFactory.Instance.creatComponentByStylename("caddy.caddyreadAwardsBGII");
         _list = ComponentFactory.Instance.creatComponentByStylename("caddy.readVBox");
         _panel = ComponentFactory.Instance.creatComponentByStylename("caddy.CaddyReaderScrollpanel");
         _panel.setView(_list);
         _panel.invalidateViewport();
         addChild(_bg2);
         addChild(_panel);
         _goodTipPos = new Point();
         _panel.invalidateViewport(true);
      }
   }
}
