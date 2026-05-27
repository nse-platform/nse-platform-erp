<div class="page-footer d-print-none">
  <div class="container-xl">
    <div class="row text-center align-items-center flex-row-reverse">
      <div class="col-lg-auto ms-lg-auto">
        <div class="text-secondary">${nowTimestamp?datetime?string.short}</div>
      </div>
      <div class="col-12 col-lg-auto mt-3 mt-lg-0">
        <div class="text-secondary">
          ${uiLabelMap.CommonCopyright} © 2001-${nowTimestamp?string("yyyy")}
          <a href="http://www.apache.org" target="_blank">ASF</a> · ${uiLabelMap.CommonPoweredBy}
          <a href="http://ofbiz.apache.org" target="_blank">Apache OFBiz</a>
          <#include "ofbizhome://VERSION" ignore_missing=true/>
          <#include "ofbizhome://runtime/GitInfo.ftl" ignore_missing=true/>
        </div>
      </div>
    </div>
  </div>
</div>
</div>
<#if layoutSettings.VT_FTR_JAVASCRIPT?has_content>
  <#list layoutSettings.VT_FTR_JAVASCRIPT as javaScript>
    <script type="text/javascript" src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>"></script>
  </#list>
</#if>
<@scriptTagsFooter/>
</body>
</html>
