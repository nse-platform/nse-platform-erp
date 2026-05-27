<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.

Theme: Tabler UI (https://tabler.io)
-->

<#-- ============================================================
     工具宏：renderClass / renderDisabled / renderAsterisks
     ============================================================ -->
<#macro renderClass className="" alert="">
  <#if className?has_content || (alert?has_content && alert == "true")>
    class="${className}<#if alert?has_content && alert == "true"> is-invalid</#if>"
  </#if>
</#macro>

<#macro renderDisabled disabled>
  <#if disabled?has_content && disabled> disabled</#if>
</#macro>

<#macro renderAsterisks requiredField>
  <#if requiredField == "true"><span class="text-danger ms-1" aria-hidden="true">*</span></#if>
</#macro>

<#-- ============================================================
     renderField
     纯文本字段输出，保持原有逻辑不变
     ============================================================ -->
<#macro renderField text="">
  <#if text??>
    ${text}<#lt/>
  </#if>
</#macro>

<#-- ============================================================
     renderDisplayField
     只读展示字段。
     - type=="image" → <img>
     - 其他          → Tabler .form-control-plaintext
     - inPlaceEditorUrl → 保留 data 属性供 JS 启用原地编辑
     ============================================================ -->
<#macro renderDisplayField imageLocation alert type="" idName="" description="" title="" class="" inPlaceEditorUrl="" inPlaceEditorParams="">
  <#if type?has_content && type == "image">
    <img src="${imageLocation}" alt="" class="img-fluid"/><#lt/>
  <#else>
    <#if inPlaceEditorUrl?has_content || class?has_content || alert == "true" || title?has_content>
      <span
      <#if inPlaceEditorUrl?has_content>
        data-inplace-editor-url="${inPlaceEditorUrl}"
        data-inplace-editor-params="${inPlaceEditorParams}"
      </#if>
      <#if idName?has_content>id="cc_${idName}"</#if>
      <#if title?has_content>title="${title}"</#if>
      class="form-control-plaintext<#if class?has_content> ${class}</#if><#if alert == "true"> text-danger</#if>"><#t/>
    </#if>
    <#if description?has_content>
      ${description?replace("\n", "<br />")}<#t/>
    <#else>
      &nbsp;<#t/>
    </#if>
    <#if inPlaceEditorUrl?has_content || class?has_content || alert == "true">
      </span><#lt/>
    </#if>
  </#if>
</#macro>

<#macro renderHyperlinkField></#macro>

<#-- ============================================================
     renderTextField
     单行文本 / number / email 等输入框 → Tabler .form-control
     AJAX 自动补全时追加必要 data 属性
     ============================================================ -->
<#macro renderTextField type step pattern name className alert value="" textSize="" maxlength="" max=0 min=0 id="" event="" action=""
        disabled=false clientAutocomplete="" ajaxUrl="" ajaxEnabled="" mask="" tabindex="" readonly="" required=false
        placeholder="" delegatorName="default">
  <input type="${type}"
    name="${name?default("")?html}"
    <@renderClass "form-control " + className alert />
    <@renderDisabled disabled />
    <#if ajaxEnabled?has_content && ajaxEnabled && ajaxUrl?has_content>
      <#local defaultMinLength = modelTheme.getAutocompleterDefaultMinLength()>
      <#local defaultDelay = modelTheme.getAutocompleterDefaultDelay()>
      data-ajax-autocomplete="true"
      data-show-description="false"
      data-default-minlength="${defaultMinLength!2}"
      data-ajax-url="${ajaxUrl!}"
      data-default-delay="${defaultDelay!300}"
    </#if>
    <#if value?has_content> value="${value}"</#if>
    <#if textSize?has_content> size="${textSize}"</#if>
    <#if maxlength?has_content> maxlength="${maxlength}"</#if>
    <#if readonly?has_content && readonly> readonly</#if>
    <#if mask?has_content> data-mask="${mask}"</#if>
    <#if id?has_content> id="${id}"</#if>
    <#if event?has_content && action?has_content> ${event}="${action}"</#if>
    <#if clientAutocomplete?has_content && clientAutocomplete == "false"> autocomplete="off"</#if>
    <#if placeholder?has_content> placeholder="${placeholder}"</#if>
    <#if tabindex?has_content> tabindex="${tabindex}"</#if>
    <#if required?has_content && required> required</#if>
    <#if pattern?has_content> pattern="${pattern}"</#if>
    <#if step?has_content> step="${step}"</#if>
  /><#t/>
</#macro>

<#-- ============================================================
     renderTextareaField
     多行文本 → Tabler .form-control
     可视化编辑器通过 data-toolbar / data-language 激活
     ============================================================ -->
<#macro renderTextareaField name className alert cols="" rows="" maxlength="" id="" readonly="" value="" visualEditorEnable="" buttons="" tabindex="" language="" disabled=false placeholder="">
  <#if visualEditorEnable?has_content>
    <#local className = className + " visual-editor">
  </#if>
  <textarea name="${name}"
  <@renderClass "form-control " + className alert />
  <@renderDisabled disabled />
  <#if cols?has_content> cols="${cols}"</#if>
  <#if rows?has_content> rows="${rows}"</#if>
  <#if id?has_content> id="${id}"</#if>
  <#if readonly?has_content && readonly == "readonly"> readonly</#if>
  <#if maxlength?has_content> maxlength="${maxlength}"</#if>
  <#if tabindex?has_content> tabindex="${tabindex}"</#if>
  <#if visualEditorEnable?has_content> data-toolbar="${buttons?default("maxi")}"</#if>
  <#if language?has_content> data-language="${language!"en"}"</#if>
  <#if placeholder?has_content> placeholder="${placeholder}"</#if>
  ><#t/>
  <#if value?has_content>${value}</#if><#t/>
  </textarea><#lt/>
</#macro>

<#-- ============================================================
     renderDateTimeField
     日期时间选择器。
     - 可见输入框 + 隐藏存储字段
     - 12 小时制下额外渲染 AM/PM 下拉
     - 所有 data-* 属性保持兼容，供 OFBiz JS 初始化
     ============================================================ -->
<#macro renderDateTimeField name className timeDropdownParamName defaultDateTimeString localizedIconTitle timeHourName timeMinutesName ampmName compositeType alert=false isTimeType=false isDateType=false amSelected=false pmSelected=false timeDropdown="" classString="" isTwelveHour=false hour1="" hour2="" minutes=0 shortDateInput="" title="" value="" size="" maxlength="" id="" formName="" mask="" event="" action="" step="" timeValues="" tabindex="" disabled=false isXMLHttpRequest=false>
  <span class="input-group view-calendar">
    <span class="input-group-text">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
           stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
        <rect x="4" y="5" width="16" height="16" rx="2"/>
        <line x1="16" y1="3" x2="16" y2="7"/><line x1="8" y1="3" x2="8" y2="7"/>
        <line x1="4" y1="11" x2="20" y2="11"/>
        <line x1="11" y1="15" x2="12" y2="15"/><line x1="12" y1="15" x2="12" y2="18"/>
      </svg>
    </span>
    <#local cultureInfo = Static["org.apache.ofbiz.common.JsLanguageFilesMappingUtil"].getFile("datejs", .locale)/>
    <#local datePickerLang = Static["org.apache.ofbiz.common.JsLanguageFilesMappingUtil"].getFile("jquery", .locale)/>
    <#local timePicker = "/common/js/node_modules/@chinchilla-software/jquery-ui-timepicker-addon/dist/jquery-ui-timepicker-addon.min.js,/common/js/node_modules/@chinchilla-software/jquery-ui-timepicker-addon/dist/jquery-ui-timepicker-addon.css"/>
    <#local timePickerLang = Static["org.apache.ofbiz.common.JsLanguageFilesMappingUtil"].getFile("dateTime", .locale)/>
    <#if !isTimeType>
      <input type="text" name="${name}_i18n"
        <@renderClass "form-control " + className alert?c />
              <@renderDisabled disabled />
              <#if tabindex?has_content> tabindex="${tabindex}"</#if>
              <#if title?has_content> title="${title}"</#if>
              <#if value?has_content> value="${value}"</#if>
              <#if size?has_content> size="${size}"</#if>
              <#if maxlength?has_content> maxlength="${maxlength}"</#if>
              <#if id?has_content> id="${id}_i18n"</#if>/><#rt/>
      <#local className = className + " date-time-picker"/>
    </#if>
    <input type="hidden" name="${name}"
      <@renderClass className alert?c />
      <@renderDisabled disabled />
      <#if tabindex?has_content> tabindex="${tabindex}"</#if>
    <#if event?has_content && action?has_content> ${event}="${action}"</#if>
      <#if title?has_content> title="${title}"</#if>
      <#if value?has_content> value="${value}"</#if>
      <#if size?has_content> size="${size}"</#if>
      <#if maxlength?has_content> maxlength="${maxlength}"</#if>
      <#if mask?has_content> data-mask="${mask}"</#if>
      <#if cultureInfo?has_content> data-cultureinfo="${cultureInfo}"</#if>
      <#if datePickerLang?has_content> data-datepickerlang="${datePickerLang}"</#if>
      <#if timePicker?has_content> data-timepicker="${timePicker}"</#if>
      <#if timePickerLang?has_content> data-timepickerlang="${timePickerLang}"</#if>
      data-shortdate="${shortDateInput?string}"
      <#if id?has_content> id="${id}"</#if>/><#rt/>
    <#if timeDropdown?has_content && timeDropdown == "time-dropdown">
      <select name="${timeHourName}" class="form-select w-auto" <@renderDisabled disabled />>
        <#if isTwelveHour>
          <#list 0..11 as i>
            <option value="${i}"<#if hour1?has_content && i == hour1> selected</#if>>${i}</option>
          </#list>
        <#else>
          <#list 0..23 as i>
            <option value="${i}"<#if hour2?has_content && i == hour2> selected</#if>>${i?string("00")}</option>
          </#list>
        </#if>
      </select>
      <span class="input-group-text">:</span>
      <select name="${timeMinutesName}" class="form-select w-auto" <@renderDisabled disabled />>
        <#local values = Static["org.apache.ofbiz.base.util.StringUtil"].toList(timeValues)>
        <#list values as i>
          <option value="${i}"<#if minutes?has_content && (i?number == minutes || ((i?number == (60 - step?number)) && (minutes > 60 - (step?number / 2))) || ((minutes > i?number) && (minutes < i?number + (step?number / 2))) || ((minutes < i?number) && (minutes > i?number - (step?number / 2))))> selected</#if>>${i}</option>
        </#list>
      </select>
      <#if isTwelveHour>
        <select name="${ampmName}" class="form-select w-auto" <@renderDisabled disabled />>
          <option value="AM"<#if amSelected> selected</#if>>AM</option>
          <option value="PM"<#if pmSelected> selected</#if>>PM</option>
        </select>
      </#if>
    </#if>
    <input type="hidden" name="${compositeType}" value="Timestamp"/>
    <#if isXMLHttpRequest>
      <script>initDateTimePicker(document.getElementById("${id}"));</script>
    </#if>
  </span>
</#macro>

<#-- ============================================================
     renderDropDownOptionList
     递归渲染 <option> 及 <optgroup>，保持原有逻辑
     ============================================================ -->
<#macro renderDropDownOptionList items currentValue multiple dDFCurrent noCurrentSelectedKey>
  <#list items as item>
    <#if item.options?has_content>
      <#if groupOpen??></optgroup></#if>
      <optgroup label="${item.description}"
      <#if item.id??> id="${item.id}"</#if>
      <#if item.widgetStyle??> class="${item.widgetStyle}"</#if>>
      <@renderDropDownOptionList item.options currentValue multiple dDFCurrent noCurrentSelectedKey/>
      <#assign groupOpen = true/>
    <#else>
      <option value="${item.key()}"
              <#if multiple>
                <#if currentValue?has_content && item.selected()> selected</#if>
                <#if !currentValue?has_content && noCurrentSelectedKey?has_content && noCurrentSelectedKey == item.key()> selected</#if>
              <#else>
                <#if currentValue?has_content && currentValue == item.key() && dDFCurrent?has_content && "selected" == dDFCurrent> selected</#if>
                <#if !currentValue?has_content && noCurrentSelectedKey?has_content && noCurrentSelectedKey == item.key()> selected</#if>
              </#if>
      >${item.description()}</option>
    </#if>
  </#list>
  <#if groupOpen??></optgroup></#if>
</#macro>

<#-- ============================================================
     renderDropDownField
     下拉选择 → Tabler .form-select
     支持 AJAX 自动补全、多选、otherField 联动
     ============================================================ -->
<#macro renderDropDownField name className id formName explicitDescription options ajaxEnabled
        otherFieldName="" otherValue="" otherFieldSize=""
        alert="" conditionGroup="" tabindex="" multiple=false event="" size="" placeCurrentValueAsFirstOption=false
        currentValue="" allowEmpty=false dDFCurrent="" noCurrentSelectedKey="" disabled=false action="">
  <#if conditionGroup?has_content>
    <input type="hidden" name="${name}_grp" value="${conditionGroup}"/>
  </#if>
  <select name="${name?default("")}"
    <@renderClass "form-select " + className alert />
    <@renderDisabled disabled />
    <#if id?has_content> id="${id}"</#if>
    <#if multiple> multiple</#if>
    <#if ajaxEnabled> data-ajax-autocomplete="true"</#if>
    <#if event?has_content> ${event}="${action}"</#if>
    <#if size?has_content> size="${size}"</#if>
    <#if tabindex?has_content> tabindex="${tabindex}"</#if>
    <#if otherFieldName?has_content>
      data-other-field-name="${otherFieldName}"
      data-other-field-value='${otherValue?js_string}'
      data-other-field-size='${otherFieldSize}'
    </#if>>
    <#if placeCurrentValueAsFirstOption && currentValue?has_content && !multiple>
      <option selected value="${currentValue}">${explicitDescription}</option>
    </#if>
    <#if allowEmpty || !options?has_content>
      <option value="">&nbsp;</option>
    </#if>
    <@renderDropDownOptionList options currentValue multiple dDFCurrent noCurrentSelectedKey/>
  </select>
  <#if otherFieldName?has_content>
    <noscript><input type="text" name="${otherFieldName}"/></noscript>
  </#if>
</#macro>

<#-- ============================================================
     renderCheckField
     复选框组 → Tabler .form-check
     ============================================================ -->
<#macro renderCheckField items className alert id name action conditionGroup="" allChecked="" currentValue="" event="" tabindex="" disabled=false>
  <#if conditionGroup?has_content>
    <input type="hidden" name="${name}_grp" value="${conditionGroup}" <@renderDisabled disabled />/>
  </#if>
  <#list items as item>
    <div class="form-check<#if className?has_content> ${className}</#if>">
      <input class="form-check-input<#if alert == "true"> is-invalid</#if>"
             type="checkbox"
        <@renderDisabled disabled />
        <#if item_index == 0> id="${id}"</#if>
        <#if tabindex?has_content> tabindex="${tabindex}"</#if>
             name="${name?default("")?html}"
             value="${item.value?default("")?html}"
      <#if event?has_content> ${event}="${action}"</#if>
      <#if allChecked?has_content && allChecked> checked</#if>
      <#if item.checked?has_content && item.checked?boolean> checked</#if>/>
      <label class="form-check-label"<#if item_index == 0> for="${id}"</#if>>
        ${item.description?default("")}
      </label>
    </div>
  </#list>
</#macro>

<#-- ============================================================
     renderRadioField
     单选按钮组 → Tabler .form-check (type="radio")
     ============================================================ -->
<#macro renderRadioField items className alert name action conditionGroup="" currentValue="" noCurrentSelectedKey="" event="" tabindex="" disabled=false>
  <#if conditionGroup?has_content>
    <input type="hidden" name="${name}_grp" value="${conditionGroup}" <@renderDisabled disabled />/>
  </#if>
  <#list items as item>
    <div class="form-check<#if className?has_content> ${className}</#if>">
      <input class="form-check-input<#if alert == "true"> is-invalid</#if>"
             type="radio"
        <@renderDisabled disabled />
             id="${name}_${item_index}"
             name="${name?default("")?html}"
             value="${item.key?default("")?html}"
      <#if event?has_content> ${event}="${action}"</#if>
      <#if tabindex?has_content> tabindex="${tabindex}"</#if>
      <#if currentValue?has_content && currentValue == item.key> checked</#if>
      <#if !currentValue?has_content && noCurrentSelectedKey?has_content && noCurrentSelectedKey == item.key> checked</#if>/>
      <label class="form-check-label" for="${name}_${item_index}">
        ${item.description}
      </label>
    </div>
  </#list>
</#macro>

<#-- ============================================================
     renderSubmitField
     提交按钮，三种形态：
       text-link → .btn.btn-link
       image     → <input type="image">
       默认      → Tabler .btn.btn-primary
     AJAX 提交时注入 ajaxSubmitFormUpdateAreas 逻辑
     ============================================================ -->
<#macro renderSubmitField buttonType className alert formName action imgSrc ajaxUrl id title="" name="" event="" confirmation="" containerId="" tabindex="" disabled=false closeOnSubmit="true">
  <#if buttonType == "text-link">
    <a class="btn btn-link<#if className?has_content> ${className}</#if>"
       href="javascript:document.${formName}.submit()"
       <#if confirmation?has_content>onclick="return confirm('${confirmation?js_string}');"</#if>>
      <#if title?has_content>${title}</#if>
    </a>
  <#elseif buttonType == "image">
    <input type="image" src="${imgSrc}"
      <@renderClass className alert />
      <@renderDisabled disabled />
      <#if name?has_content> name="${name}"</#if>
      <#if title?has_content> alt="${title}"</#if>
      <#if event?has_content> ${event}="${action}"</#if>
      <#if confirmation?has_content> onclick="return confirm('${confirmation?js_string}');"</#if>/>
  <#else>
    <button type="submit"
      class="btn btn-primary<#if className?has_content> ${className}</#if><#if alert == "true"> btn-danger</#if>"
      <@renderDisabled disabled />
      <#if id?has_content> id="${id}"</#if>
      <#if name??> name="${name}"</#if>
      <#if event?has_content> ${event}="${action}"</#if>
      <#if !containerId?has_content>
        <#if confirmation?has_content> onclick="return confirm('${confirmation?js_string}');"</#if>
        <#if tabindex?has_content> tabindex="${tabindex}"</#if>
      </#if>>
      <#if title?has_content>${title}</#if>
    </button>
    <#if containerId?has_content>
      <script>
        $("form[name='${formName}']")
          .submit(function (e) {
            e.preventDefault();
            e.stopPropagation();
            if ($(this).valid()) {
              <#if confirmation?has_content>if (confirm('${confirmation?js_string}')) </#if>
              ajaxSubmitFormUpdateAreas('${formName}', '${ajaxUrl}', '${closeOnSubmit}');
            }
          })
          .keypress(function (e) {
            if (e.which === 13 && !$(e.target).is('textarea')) {
              e.preventDefault();
              $("#${id!}").click();
            }
          });
      </script>
    </#if>
  </#if>
</#macro>

<#-- ============================================================
     renderResetField → Tabler .btn.btn-secondary (type="reset")
     ============================================================ -->
<#macro renderResetField className alert name title="">
  <button type="reset"
          class="btn btn-secondary<#if className?has_content> ${className}</#if><#if alert == "true"> btn-danger</#if>"
          name="${name}">
    <#if title?has_content>${title}<#else>Reset</#if>
  </button>
</#macro>

<#-- ============================================================
     renderHiddenField
     隐藏字段，行为不变，支持 conditionGroup
     ============================================================ -->
<#macro renderHiddenField name conditionGroup="" value="" id="" event="" action="" disabled=false>
  <#if conditionGroup?has_content>
    <input type="hidden" name="${name}_grp" value="${conditionGroup}" <@renderDisabled disabled />/>
  </#if>
  <input type="hidden" name="${name}"
    <@renderDisabled disabled />
    <#if value?has_content> value="${value}"</#if>
    <#if id?has_content> id="${id}"</#if>
    <#if event?has_content && action?has_content> ${event}="${action}"</#if>/>
</#macro>

<#macro renderIgnoredField></#macro>

<#-- ============================================================
     renderFieldTitle
     字段标签 → Tabler .form-label
     fieldHelpText 通过 title 属性呈现 tooltip
     ============================================================ -->
<#macro renderFieldTitle style title id fieldHelpText="" for="">
  <label
  class="form-label<#if style?has_content> ${style}</#if>"
  <#if for?has_content> for="${for}"</#if>
  <#if id?has_content> id="${id}"</#if>
<#if fieldHelpText?has_content> title="${fieldHelpText}" data-bs-toggle="tooltip"</#if>><#t/>
  ${title}<#t/>
  <#if fieldHelpText?has_content>
    <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm text-muted ms-1" width="14" height="14" viewBox="0 0 24 24"
         stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
      <circle cx="12" cy="12" r="9"/>
      <line x1="12" y1="8" x2="12.01" y2="8"/>
      <polyline points="11 12 12 12 12 16 13 16"/>
    </svg>
  </#if>
  </label><#t/>
</#macro>

<#macro renderEmptyFormDataMessage message>
  <div class="empty">
    <div class="empty-icon">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-lg" width="40" height="40" viewBox="0 0 24 24"
           stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
        <circle cx="12" cy="12" r="9"/>
        <line x1="12" y1="8" x2="12" y2="12"/>
        <line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>
    </div>
    <p class="empty-title"><#if message?has_content>${message}</#if></p>
  </div>
</#macro>

<#macro renderSingleFormFieldTitle></#macro>

<#-- ============================================================
     renderFormOpen
     表单开标签，支持文件上传、CSRF、分页隐藏字段
     class 保持 OFBiz 原有钩子 basic-form / containerStyle
     ============================================================ -->
<#macro renderFormOpen linkUrl formType name viewIndexField viewSizeField viewIndex viewSize targetWindow="" containerId="" containerStyle="" autocomplete="" useRowSubmit="" focusFieldName="" hasRequiredField="" csrfNameValue="">
<form method="post" action="${linkUrl}"
        <#if formType == "upload"> enctype="multipart/form-data"</#if>
        <#if targetWindow?has_content> target="${targetWindow}"</#if>
        <#if containerId?has_content> id="${containerId}"</#if>
        <#if focusFieldName?has_content> data-focus-field="${focusFieldName}"</#if>
      class="<#if containerStyle?has_content>${containerStyle}<#else>basic-form</#if>"
      onsubmit="javascript:submitFormDisableSubmits(this)"
        <#if autocomplete?has_content> autocomplete="${autocomplete}"</#if>
      name="${name}"><#lt/>
  <#if csrfNameValue?has_content>
    <#assign result = csrfNameValue?matches(r"(\w+) (\w+)")>
    <#if result>
      <input type="hidden" name="${result?groups[1]}" value="${result?groups[2]}"/>
    </#if>
  </#if>
  <#if useRowSubmit?has_content && useRowSubmit>
    <input type="hidden" name="_useRowSubmit" value="Y"/>
    <#if linkUrl?index_of("VIEW_INDEX") <= 0 && linkUrl?index_of(viewIndexField) <= 0>
      <input type="hidden" name="${viewIndexField}" value="${viewIndex}"/>
    </#if>
    <#if linkUrl?index_of("VIEW_SIZE") <= 0 && linkUrl?index_of(viewSizeField) <= 0>
      <input type="hidden" name="${viewSizeField}" value="${viewSize}"/>
    </#if>
  </#if>
  </#macro>

  <#macro renderFormClose></form><#lt/></#macro>
<#macro renderMultiFormClose></form><#lt/></#macro>

<#-- ============================================================
     列表表格结构
     → Tabler .table .table-vcenter .card-table
     ============================================================ -->
<#macro renderFormatListWrapperOpen formName columnStyles style="">
<div class="table-responsive">
  <table class="table table-vcenter card-table<#if !style?has_content> table-striped</#if><#if style?has_content> ${style}</#if>"><#lt/>
    </#macro>

    <#macro renderFormatListWrapperClose formName>
  </table>
</div><#lt/>
</#macro>

<#macro renderFormatHeaderOpen><thead></#macro>
<#macro renderFormatHeaderClose></thead></#macro>

<#macro renderFormatHeaderRowOpen style="">
<tr<#if style?has_content> class="${style}"</#if>>
  </#macro>
  <#macro renderFormatHeaderRowClose></tr></#macro>

<#macro renderFormatHeaderRowCellOpen style="" positionSpan="">
<th<#if positionSpan?has_content && positionSpan?number gt 1> colspan="${positionSpan}"</#if><#if style?has_content> class="${style}"</#if>>
  </#macro>
  <#macro renderFormatHeaderRowCellClose></th></#macro>

<#macro renderFormatHeaderRowFormCellOpen style="">
<th<#if style?has_content> class="${style}"</#if>>
  </#macro>
  <#macro renderFormatHeaderRowFormCellClose></th></#macro>

<#macro renderFormatHeaderRowFormCellTitleSeparator isLast style="">
  <#if style?has_content><span class="${style}"></#if> - <#if style?has_content></span></#if>
</#macro>

<#macro renderFormatItemRowOpen formName itemIndex="" altRowStyles="" evenRowStyle="" oddRowStyle="">
<tr<#if itemIndex?has_content>
  <#if (itemIndex?number % 2 == 0)>
    <#if evenRowStyle?has_content> class="${evenRowStyle}<#if altRowStyles?has_content> ${altRowStyles}</#if>"
    <#elseif altRowStyles?has_content> class="${altRowStyles}"</#if>
  <#else>
    <#if oddRowStyle?has_content> class="${oddRowStyle}<#if altRowStyles?has_content> ${altRowStyles}</#if>"
    <#elseif altRowStyles?has_content> class="${altRowStyles}"</#if>
  </#if>
        </#if>>
  </#macro>
  <#macro renderFormatItemRowClose formName></tr></#macro>

<#macro renderFormatItemRowCellOpen fieldName style="" positionSpan="">
<td<#if positionSpan?has_content && positionSpan?number gt 1> colspan="${positionSpan}"</#if><#if style?has_content> class="${style}"</#if>>
  </#macro>
  <#macro renderFormatItemRowCellClose fieldName></td></#macro>

<#macro renderFormatItemRowFormCellOpen style="">
<td<#if style?has_content> class="${style}"</#if>>
  </#macro>
  <#macro renderFormatItemRowFormCellClose></td></#macro>

<#-- ============================================================
     单记录表单（Single Form）布局
     Tabler 推荐用 .row / .col 替代 <table>，但此处保留
     table 兼容原有 Java 渲染器的 colspan 计算
     ============================================================ -->
<#macro renderFormatSingleWrapperOpen formName style="">
<table cellspacing="0" class="table table-borderless table-sm<#if style?has_content> ${style}</#if>">
  </#macro>
  <#macro renderFormatSingleWrapperClose formName></table></#macro>

<#macro renderFormatFieldRowOpen><tr></#macro>
  <#macro renderFormatFieldRowClose></tr></#macro>

<#macro renderFormatFieldRowTitleCellOpen style="">
<td class="align-middle text-end text-nowrap pe-3<#if style?has_content> ${style}</#if>" style="width:1%">
  </#macro>
  <#macro renderFormatFieldRowTitleCellClose></td></#macro>

<#macro renderFormatFieldRowSpacerCell></#macro>

<#macro renderFormatFieldRowWidgetCellOpen positionSpan="" style="">
<td<#if positionSpan?has_content && positionSpan?number gt 0> colspan="${1 + positionSpan?number * 3}"</#if><#if style?has_content> class="${style}"</#if>>
  </#macro>
  <#macro renderFormatFieldRowWidgetCellClose></td></#macro>

<#macro renderFormatEmptySpace>&nbsp;</#macro>

<#-- ============================================================
     renderTextFindField
     文本搜索字段（含操作符下拉 + 大小写忽略开关）
     ============================================================ -->
<#macro renderTextFindField name defaultOption opBeginsWith opContains opIsEmpty opNotEqual className alert hideIgnoreCase ignCase ignoreCase conditionGroup="" value="" opEquals="" size="" maxlength="" autocomplete="" titleStyle="" tabindex="" disabled=false>
  <#if conditionGroup?has_content>
    <input type="hidden" name="${name}_grp" value="${conditionGroup}" <@renderDisabled disabled />/>
  </#if>
  <div class="input-group">
    <#if opEquals?has_content>
      <select <@renderDisabled disabled /> name="${name}_op" class="form-select w-auto flex-grow-0">
        <option value="equals"<#if defaultOption == "equals"> selected</#if>>${opEquals}</option>
        <option value="like"<#if defaultOption == "like"> selected</#if>>${opBeginsWith}</option>
        <option value="contains"<#if defaultOption == "contains"> selected</#if>>${opContains}</option>
        <option value="empty"<#if defaultOption == "empty"> selected</#if>>${opIsEmpty}</option>
        <option value="notEqual"<#if defaultOption == "notEqual"> selected</#if>>${opNotEqual}</option>
      </select>
    <#else>
      <input type="hidden" name="${name}_op" value="${defaultOption}"/>
    </#if>
    <input type="text"
            <@renderClass "form-control " + className alert />
            <@renderDisabled disabled />
           name="${name}"
            <#if value?has_content> value="${value}"</#if>
            <#if size?has_content> size="${size}"</#if>
            <#if maxlength?has_content> maxlength="${maxlength}"</#if>
            <#if autocomplete?has_content> autocomplete="off"</#if>
            <#if tabindex?has_content> tabindex="${tabindex}"</#if>/>
    <#if !hideIgnoreCase>
      <span class="input-group-text">
        <label class="form-check mb-0">
          <input type="checkbox" class="form-check-input" name="${name}_ic" value="Y"<#if ignCase> checked</#if> <@renderDisabled disabled />/>
          <span class="form-check-label">${ignoreCase}</span>
        </label>
      </span>
    <#else>
      <input type="hidden" name="${name}_ic" value="<#if ignCase>Y</#if>"/>
    </#if>
  </div>
</#macro>

<#-- ============================================================
     renderDateFindField
     日期范围搜索字段（from / thru 各一个输入框 + 操作符下拉）
     支持法语布局（操作符在输入框左侧）
     ============================================================ -->
<#macro renderDateFindField id name formName defaultOptionFrom defaultOptionThru opEquals opSameDay opGreaterThanFromDayStart opGreaterThan opGreaterThan opLessThan opUpToDay opUpThruDay opIsEmpty language="" className="" alert=false imgSrc="" value="" isTimeType=false isDateType=false conditionGroup="" localizedInputTitle="" value2="" size="" maxlength="" titleStyle="" tabindex="" disabled=false>
  <#if conditionGroup?has_content>
    <input type="hidden" name="${name}_grp" value="${conditionGroup}" <@renderDisabled disabled />/>
  </#if>
  <#if !isTimeType><#local className = className + " date-time-picker"/></#if>
  <#local shortDateInput = isDateType/>
  <#local cultureInfo = Static["org.apache.ofbiz.common.JsLanguageFilesMappingUtil"].getFile("datejs", .locale)/>
  <#local datePickerLang = Static["org.apache.ofbiz.common.JsLanguageFilesMappingUtil"].getFile("jquery", .locale)/>
  <#local timePicker = "/common/js/node_modules/@chinchilla-software/jquery-ui-timepicker-addon/dist/jquery-ui-timepicker-addon.min.js,/common/js/node_modules/@chinchilla-software/jquery-ui-timepicker-addon/dist/jquery-ui-timepicker-addon.css"/>
  <#local timePickerLang = Static["org.apache.ofbiz.common.JsLanguageFilesMappingUtil"].getFile("dateTime", .locale)/>
  <div class="row g-2 view-calendar">
    <#-- From 日期 -->
    <div class="col-auto">
      <div class="input-group">
        <#if language?matches("fr.*")>
          <select <@renderDisabled disabled /> name="${name}_fld0_op" class="form-select w-auto flex-grow-0">
            <option value="equals"<#if defaultOptionFrom == "equals"> selected</#if>>${opEquals}</option>
            <option value="sameDay"<#if defaultOptionFrom == "sameDay"> selected</#if>>${opSameDay}</option>
            <option value="greaterThanFromDayStart"<#if defaultOptionFrom == "greaterThanFromDayStart"> selected</#if>>${opGreaterThanFromDayStart}</option>
            <option value="greaterThan"<#if defaultOptionFrom == "greaterThan"> selected</#if>>${opGreaterThan}</option>
          </select>
        </#if>
        <input id="${id}_fld0_value" type="text"
                <@renderClass "form-control " + className alert?c />
                <@renderDisabled disabled />
                <#if name?has_content> name="${name?html}_fld0_value"</#if>
                <#if localizedInputTitle?has_content> title="${localizedInputTitle}"</#if>
                <#if value?has_content> value="${value}"</#if>
                <#if size?has_content> size="${size}"</#if>
                <#if maxlength?has_content> maxlength="${maxlength}"</#if>
                <#if tabindex?has_content> tabindex="${tabindex}"</#if>
                <#if cultureInfo?has_content> data-cultureinfo="${cultureInfo}"</#if>
                <#if datePickerLang?has_content> data-datepickerlang="${datePickerLang}"</#if>
                <#if timePicker?has_content> data-timepicker="${timePicker}"</#if>
                <#if timePickerLang?has_content> data-timepickerlang="${timePickerLang}"</#if>
               data-shortdate="${shortDateInput?string}"/>
        <#if !language?matches("fr.*")>
          <select <@renderDisabled disabled /> name="${name}_fld0_op" class="form-select w-auto flex-grow-0">
            <option value="equals"<#if defaultOptionFrom == "equals"> selected</#if>>${opEquals}</option>
            <option value="sameDay"<#if defaultOptionFrom == "sameDay"> selected</#if>>${opSameDay}</option>
            <option value="greaterThanFromDayStart"<#if defaultOptionFrom == "greaterThanFromDayStart"> selected</#if>>${opGreaterThanFromDayStart}</option>
            <option value="greaterThan"<#if defaultOptionFrom == "greaterThan"> selected</#if>>${opGreaterThan}</option>
          </select>
        </#if>
      </div>
    </div>
    <#-- Thru 日期 -->
    <div class="col-auto">
      <div class="input-group">
        <#if language?matches("fr.*")>
          <select name="${name}_fld1_op" class="form-select w-auto flex-grow-0" <@renderDisabled disabled />>
            <option value="opLessThan"<#if defaultOptionThru == "opLessThan"> selected</#if>>${opLessThan}</option>
            <option value="upToDay"<#if defaultOptionThru == "upToDay"> selected</#if>>${opUpToDay}</option>
            <option value="upThruDay"<#if defaultOptionThru == "upThruDay"> selected</#if>>${opUpThruDay}</option>
            <option value="empty"<#if defaultOptionFrom == "empty"> selected</#if>>${opIsEmpty}</option>
          </select>
        </#if>
        <input id="${id}_fld1_value" type="text"
                <@renderClass "form-control " + className alert?c />
                <@renderDisabled disabled />
                <#if name?has_content> name="${name}_fld1_value"</#if>
                <#if localizedInputTitle??> title="${localizedInputTitle?html}"</#if>
                <#if value2?has_content> value="${value2}"</#if>
                <#if size?has_content> size="${size}"</#if>
                <#if maxlength?has_content> maxlength="${maxlength}"</#if>
                <#if cultureInfo?has_content> data-cultureinfo="${cultureInfo}"</#if>
                <#if datePickerLang?has_content> data-datepickerlang="${datePickerLang}"</#if>
                <#if timePicker?has_content> data-timePicker="${timePicker}"</#if>
                <#if timePickerLang?has_content> data-timepickerlang="${timePickerLang}"</#if>
               data-shortdate="${shortDateInput?string}"/>
        <#if !language?matches("fr.*")>
          <select name="${name}_fld1_op" class="form-select w-auto flex-grow-0" <@renderDisabled disabled />>
            <option value="opLessThan"<#if defaultOptionThru == "opLessThan"> selected</#if>>${opLessThan}</option>
            <option value="upToDay"<#if defaultOptionThru == "upToDay"> selected</#if>>${opUpToDay}</option>
            <option value="upThruDay"<#if defaultOptionThru == "upThruDay"> selected</#if>>${opUpThruDay}</option>
            <option value="empty"<#if defaultOptionFrom == "empty"> selected</#if>>${opIsEmpty}</option>
          </select>
        </#if>
      </div>
    </div>
  </div>
</#macro>

<#-- ============================================================
     renderRangeFindField
     数值范围搜索（from + to 两个输入 + 各自操作符下拉）
     原有 <br> 分隔改为 .row 布局
     ============================================================ -->
<#macro renderRangeFindField className alert value defaultOptionFrom opEquals opGreaterThan opGreaterThanEquals opLessThan opLessThanEquals defaultOptionThru conditionGroup="" name="" size="" maxlength="" autocomplete="" titleStyle="" value2="" tabindex="" disabled=false>
  <#if conditionGroup?has_content>
    <input type="hidden" name="${name}_grp" value="${conditionGroup}" <@renderDisabled disabled />/>
  </#if>
  <div class="row g-2">
    <div class="col-auto">
      <div class="input-group">
        <input type="text"
                <@renderClass "form-control " + className alert />
                <@renderDisabled disabled />
                <#if name?has_content> name="${name}_fld0_value"</#if>
                <#if value?has_content> value="${value}"</#if>
                <#if size?has_content> size="${size}"</#if>
                <#if maxlength?has_content> maxlength="${maxlength}"</#if>
                <#if autocomplete?has_content> autocomplete="off"</#if>
                <#if tabindex?has_content> tabindex="${tabindex}"</#if>/>
        <select <@renderDisabled disabled /> <#if name?has_content>name="${name}_fld0_op"</#if> class="form-select w-auto flex-grow-0">
          <option value="equals"<#if defaultOptionFrom == "equals"> selected</#if>>${opEquals}</option>
          <option value="greaterThan"<#if defaultOptionFrom == "greaterThan"> selected</#if>>${opGreaterThan}</option>
          <option value="greaterThanEqualTo"<#if defaultOptionFrom == "greaterThanEqualTo"> selected</#if>>${opGreaterThanEquals}</option>
        </select>
      </div>
    </div>
    <div class="col-auto">
      <div class="input-group">
        <input type="text"
                <@renderClass "form-control " + className alert />
                <@renderDisabled disabled />
                <#if name?has_content> name="${name}_fld1_value"</#if>
                <#if value2?has_content> value="${value2}"</#if>
                <#if size?has_content> size="${size}"</#if>
                <#if maxlength?has_content> maxlength="${maxlength}"</#if>
                <#if autocomplete?has_content> autocomplete="off"</#if>/>
        <select <@renderDisabled disabled /> <#if name?has_content>name="${name}_fld1_op"</#if> class="form-select w-auto flex-grow-0">
          <option value="lessThan"<#if defaultOptionThru == "lessThan"> selected</#if>>${opLessThan?html}</option>
          <option value="lessThanEqualTo"<#if defaultOptionThru == "lessThanEqualTo"> selected</#if>>${opLessThanEquals?html}</option>
        </select>
      </div>
    </div>
  </div>
</#macro>

<#-- ============================================================
     renderDateRangePicker
     daterangepicker 组件，保持原有 JS 逻辑，
     清除按钮改为 Tabler .btn.btn-ghost-secondary
     ============================================================ -->
<#macro renderDateRangePicker className alert id name value formName event action locale
alwaysShowCalendars applyButtonClasses applyLabel autoApply buttonClasses cancelButtonClasses cancelLabel clearTitle
drops linkedCalendars maxSpan maxYear minYear opens rangeLastMonthLabel rangeLastWeekLabel rangeNextMonthLabel
rangeNextWeekLabel rangeThisMonthLabel rangeThisWeekLabel showDropdowns showIsoWeekNumbers showRanges showWeekNumbers
singleDatePicker timePicker timePicker24Hour timePickerIncrement timePickerSeconds
conditionGroup="" value2="" titleStyle="" tabindex="">
  <#if conditionGroup?has_content>
    <input type="hidden" name="${name}_grp" value="${conditionGroup}"/>
  </#if>
  <div class="input-group view-calendar drp <#if timePicker>time<#else>no-time</#if> <#if singleDatePicker>single<#else>range</#if> <#if timePickerSeconds>seconds<#else>no-seconds</#if>">
    <span class="input-group-text">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
           stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
        <rect x="4" y="5" width="16" height="16" rx="2"/>
        <line x1="16" y1="3" x2="16" y2="7"/><line x1="8" y1="3" x2="8" y2="7"/>
        <line x1="4" y1="11" x2="20" y2="11"/>
      </svg>
    </span>
    <#if !singleDatePicker>
      <input id="${id}_fld0_op" type="hidden" value="greaterThan" <#if name?has_content>name="${name}_fld0_op"</#if>/>
      <input id="${id}_fld0_value" type="hidden"
        <#if name?has_content> name="${name?html}_fld0_value"</#if>
        <#if value?has_content> value="${value}"</#if>
        <#if event?has_content && action?has_content> ${event}="${action}"</#if>/>
      <input id="${id}_fld1_op" type="hidden" value="opLessThan" <#if name?has_content>name="${name}_fld1_op"</#if>/>
      <input id="${id}_fld1_value" type="hidden"
        <#if name?has_content> name="${name?html}_fld1_value"</#if>
        <#if value2?has_content> value="${value2}"</#if>
        <#if event?has_content && action?has_content> ${event}="${action}"</#if>/>
      <input id="${id}" type="text" value=""
        <@renderClass "form-control " + className alert />
        <#if tabindex?has_content> tabindex="${tabindex}"</#if>/>
    <#else>
      <input type="text" name="${name}_i18n"
        <@renderClass "form-control " + className alert />
        <#if tabindex?has_content> tabindex="${tabindex}"</#if>
        <#if value?has_content> value="${value}"</#if>
        <#if id?has_content> id="${id}_i18n"</#if>/>
      <input type="hidden" name="${name}"
        <@renderClass className alert />
        <#if event?has_content && action?has_content> ${event}="${action}"</#if>
        <#if tabindex?has_content> tabindex="${tabindex}"</#if>
        <#if value?has_content> value="${value}"</#if>
        <#if id?has_content> id="${id}"</#if>/>
    </#if>
    <button id="${id}_clear" type="button" class="btn btn-ghost-secondary" title="${clearTitle}">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
           stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
        <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
      </svg>
    </button>
  </div>
  <script>
    $(document).ready(function () {
      moment.locale('${locale}');
      const u = (i) => i.replaceAll('&#x3a;', ':');
      const timePicker = ${timePicker?c};
      const timePickerSeconds = ${timePickerSeconds?c};
      const singleDatePicker = ${singleDatePicker?c};
      const outputFormat = 'YYYY-MM-DD' + ((timePicker || !singleDatePicker) ? ' HH:mm:ss' : '');
      let displayFormat = 'DD/MM/YYYY' + (timePicker ? ' HH:mm' : '') + (timePicker && timePickerSeconds ? ':ss' : '');
      const start = u('${value}');
      const end = u('${value2}');
      const visibleInput = singleDatePicker ? $('input[name="${name}_i18n"]') : $('#${id}');
      const hiddenInputs = singleDatePicker ? $('[name="${name}"]') : $('#${id}_fld0_value, #${id}_fld1_value');

      visibleInput.daterangepicker({
        alwaysShowCalendars: ${alwaysShowCalendars?c},
        <#if applyButtonClasses?has_content>applyButtonClasses: '${applyButtonClasses}',</#if>
        autoUpdateInput: false,
        autoApply: ${autoApply?c},
        <#if buttonClasses?has_content>buttonClasses: '${buttonClasses}',</#if>
        <#if cancelButtonClasses?has_content>cancelButtonClasses: '${cancelButtonClasses}',</#if>
        <#if drops?has_content>drops: '${drops}',</#if>
        endDate: end ? moment(end) : undefined,
        linkedCalendars: ${linkedCalendars?c},
        locale: {
          <#if applyLabel?has_content>applyLabel: '${applyLabel}',</#if>
          <#if cancelLabel?has_content>cancelLabel: '${cancelLabel}',</#if>
          weekLabel: 'S'
        },
        <#if maxSpan?has_content>maxSpan: { days: ${maxSpan} },</#if>
        <#if maxYear?has_content>maxYear: ${maxYear},</#if>
        <#if minYear?has_content>minYear: ${minYear},</#if>
        <#if opens?has_content>opens: '${opens}',</#if>
        <#if showRanges && !singleDatePicker>
        ranges: {
          '${rangeThisWeekLabel}': [moment().startOf('week'), moment().endOf('week')],
          '${rangeLastWeekLabel}': [moment().subtract(1, 'week').startOf('week'), moment().subtract(1, 'week').endOf('week')],
          '${rangeNextWeekLabel}': [moment().add(1, 'week').startOf('week'), moment().add(1, 'week').endOf('week')],
          '${rangeThisMonthLabel}': [moment().startOf('month'), moment().endOf('month')],
          '${rangeLastMonthLabel}': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
          '${rangeNextMonthLabel}': [moment().add(1, 'month').startOf('month'), moment().add(1, 'month').endOf('month')]
        },
        </#if>
        showCustomRangeLabel: false,
        showDropdowns: ${showDropdowns?c},
        showIsoWeekNumbers: ${showIsoWeekNumbers?c},
        showWeekNumbers: ${showWeekNumbers?c},
        singleDatePicker,
        startDate: start ? moment(start) : undefined,
        timePicker,
        timePicker24Hour: ${timePicker24Hour?c},
        <#if timePickerIncrement?has_content>timePickerIncrement: ${timePickerIncrement},</#if>
        timePickerSeconds
      });

      updateInputs(moment(start), moment(end));
      visibleInput.on('apply.daterangepicker', function (ev, picker) { updateInputs(picker.startDate, picker.endDate); });
      $('#${id}_clear').on('click', function (e) {
        e.preventDefault();
        visibleInput.val('');
        hiddenInputs.val('');
      });
      visibleInput.on('paste', function (e) {
        e.preventDefault();
        const text = (e.originalEvent || e).clipboardData.getData('text/plain');
        updateInputs(moment(text, displayFormat));
      });
      visibleInput.on('input', function (e) {
        const text = e.target.value;
        if (text.length === 10) { updateInputs(moment(text, displayFormat)); }
      });

      function updateInputs(start, end) {
        if (start.isValid()) {
          if (singleDatePicker) {
            visibleInput.val(start.format(displayFormat));
            hiddenInputs.val(start.format(outputFormat)).trigger('change');
          } else if (end.isValid()) {
            visibleInput.val(start.format(displayFormat) + ' ➜ ' + end.format(displayFormat)).trigger('change');
            $('#${id}_fld0_value').val(start.format(outputFormat)).trigger('change');
            $('#${id}_fld1_value').val(end.format(outputFormat)).trigger('change');
          }
        }
      }
    });
  </script>
</#macro>

<#-- ============================================================
     renderLookupField
     弹出查找字段 → .input-group，清除按钮改为 Tabler 风格
     所有 data-lookup-* 属性保持兼容
     ============================================================ -->
<#macro renderLookupField name formName fieldFormName conditionGroup="" className="" alert="false" value="" size=""
        maxlength="" id="" event="" action="" readonly=false autocomplete="" descriptionFieldName="" targetParameterIter=""
        imgSrc="" ajaxUrl="" ajaxEnabled=javaScriptEnabled presentation="layer" width=modelTheme.getLookupWidth()
        height=modelTheme.getLookupHeight() position=modelTheme.getLookupPosition() fadeBackground="true" clearText=""
        showDescription="" initiallyCollapsed="" lastViewName="main" tabindex="" delegatorName="default" disabled=false>
  <#if Static["org.apache.ofbiz.widget.model.ModelWidget"].widgetBoundaryCommentsEnabled(context)>
  <!-- @renderLookupField -->
  </#if>
  <#if !showDescription?has_content>
    <#local showDescription = "false"/>
    <#if "Y" == modelTheme.getLookupShowDescription()><#local showDescription = "true"/></#if>
  </#if>
  <#if !ajaxUrl?has_content && ajaxEnabled?has_content && ajaxEnabled>
    <#local ajaxUrl = requestAttributes._REQUEST_HANDLER_.makeLink(request, response, fieldFormName)/>
    <#local ajaxUrl = id + "," + ajaxUrl + ",ajaxLookup=Y"/>
  </#if>
  <#if ajaxEnabled?has_content && ajaxEnabled && presentation?has_content && "window" == presentation>
    <#local ajaxUrl = ajaxUrl + "&amp;_LAST_VIEW_NAME_=" + lastViewName/>
  </#if>
  <#if conditionGroup?has_content>
    <input type="hidden" name="${name}_grp" value="${conditionGroup}" <@renderDisabled disabled />/>
  </#if>
  <div class="input-group field-lookup">
    <#if size?has_content && size == "0">
      <input type="hidden" <@renderDisabled disabled />
        <#if name?has_content> name="${name}"</#if>
        <#if tabindex?has_content> tabindex="${tabindex}"</#if>
    <#else>
      <input type="text"
        <@renderClass "form-control " + className alert />
        <@renderDisabled disabled />
        <#if name?has_content> name="${name}"</#if>
        <#if value?has_content> value="${value}"</#if>
        <#if tabindex?has_content> tabindex="${tabindex}"</#if>
        <#if size?has_content> size="${size}"</#if>
        <#if maxlength?has_content> maxlength="${maxlength}"</#if>
        <#if id?has_content> id="${id}"</#if>
        <#if readonly?has_content && readonly> readonly</#if>
        <#if event?has_content && action?has_content> ${event}="${action}"</#if>
        <#if autocomplete?has_content> autocomplete="off"</#if>
    </#if>
      data-lookup-ajax-enabled="<#if ajaxEnabled?has_content>${ajaxEnabled?string}<#else>false</#if>"
      data-lookup-presentation="${presentation!}"
      <#if presentation?has_content && descriptionFieldName?has_content && "window" == presentation>
        data-lookup-field-formname="${fieldFormName}"
        data-lookup-form-name="${formName?html}"
        data-lookup-description-field="${descriptionFieldName}"
        <#if targetParameterIter?has_content>
          <#local args = "${targetParameterIter?join(', ')}">
        </#if>
        data-lookup-args="${args!}"
      <#elseif presentation?has_content && "window" == presentation>
        data-lookup-field-formname="${fieldFormName}"
        <#if targetParameterIter?has_content>
          <#local args = "${targetParameterIter?join(', ')}">
        </#if>
        data-lookup-args="${args!}"
      <#else>
        <#if ajaxEnabled?has_content && ajaxEnabled>
          <#local defaultMinLength = modelTheme.getAutocompleterDefaultMinLength()>
          <#local defaultDelay = modelTheme.getAutocompleterDefaultDelay()>
          <#if !ajaxUrl?contains("searchValueFieldName=")>
            <#if descriptionFieldName?has_content && "true" == showDescription>
              <#local ajaxUrl = ajaxUrl + "&amp;searchValueFieldName=" + descriptionFieldName/>
            <#else>
              <#local ajaxUrl = ajaxUrl + "&amp;searchValueFieldName=" + name/>
            </#if>
          </#if>
        </#if>
        data-lookup-request-url="${fieldFormName}"
        data-lookup-form-name="${formName?html}"
        data-lookup-optional-target="<#if descriptionFieldName?has_content>${descriptionFieldName}</#if>"
        data-lookup-width="${width}"
        data-lookup-height="${height}"
        data-lookup-position="${position}"
        data-lookup-modal="${fadeBackground}"
        data-lookup-show-description=<#if ajaxEnabled?has_content && ajaxEnabled>"${showDescription}"<#else>"false"</#if>
        data-lookup-default-minlength="${defaultMinLength!2}"
        data-lookup-default-delay="${defaultDelay!300}"
        <#if targetParameterIter?has_content>
          <#local args = "${targetParameterIter?join(', ')}">
        </#if>
        data-lookup-args="${args!}"
      </#if>
      data-lookup-ajax-url="${ajaxUrl}"
    />
    <#if !(readonly?has_content && readonly)>
      <button type="button" class="btn btn-outline-secondary lookup-btn"
              data-lookup-id="${id!}"
              title="Lookup">
        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
          <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
          <circle cx="10" cy="10" r="7"/>
          <line x1="21" y1="21" x2="15" y2="15"/>
        </svg>
      </button>
    </#if>
    <#if readonly?has_content && readonly>
      <button type="button" id="${id}_clear" class="btn btn-ghost-secondary" title="Clear">
        <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-sm" width="16" height="16" viewBox="0 0 24 24"
             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
          <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
          <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
        </svg>
        <#if clearText?has_content>${clearText}<#else>${uiLabelMap.CommonClear}</#if>
      </button>
    </#if>
  </div>
</#macro>

<#-- ============================================================
     renderNextPrev
     列表分页 → Tabler .pagination + 每页条数 .form-select
     ============================================================ -->
<#macro renderNextPrev paginateStyle paginateFirstStyle viewIndex highIndex listSize viewSize ajaxEnabled javaScriptEnabled ajaxFirstUrl firstUrl paginateFirstLabel ajaxPreviousUrl previousUrl paginatePreviousLabel pageLabel ajaxSelectUrl selectUrl ajaxSelectSizeUrl selectSizeUrl commonDisplaying paginateNextStyle ajaxNextUrl nextUrl paginateNextLabel paginateLastStyle ajaxLastUrl lastUrl paginateLastLabel paginateViewSizeLabel paginatePreviousStyle="">
  <#if listSize gt viewSize>
    <div class="d-flex align-items-center gap-3 flex-wrap ${paginateStyle}">
      <ul class="pagination mb-0">
        <#-- 首页 -->
        <li class="page-item<#if viewIndex == 0> disabled</#if>">
          <a class="page-link" href="javascript:void(0)"
             <#if viewIndex gt 0>onclick="<#if ajaxEnabled>ajaxUpdateAreas('${ajaxFirstUrl}')<#else>submitPagination(this, '${firstUrl}')</#if>"</#if>
             title="${paginateFirstLabel}">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none"><path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="11 7 6 12 11 17"/><polyline points="17 7 12 12 17 17"/>
            </svg>
          </a>
        </li>
        <#-- 上一页 -->
        <li class="page-item<#if viewIndex == 0> disabled</#if>">
          <a class="page-link" href="javascript:void(0)"
             <#if viewIndex gt 0>onclick="<#if ajaxEnabled>ajaxUpdateAreas('${ajaxPreviousUrl}')<#else>submitPagination(this, '${previousUrl}')</#if>"</#if>>
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none"><path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="15 6 9 12 15 18"/>
            </svg>
          </a>
        </li>
        <#-- 页码输入 -->
        <#if listSize gt 0 && javaScriptEnabled>
          <li class="page-item disabled">
            <span class="page-link d-flex align-items-center gap-1">
              ${pageLabel}
              <input type="text" class="form-control form-control-sm d-inline-block"
                     style="width:5rem; text-align:center;"
                     placeholder="${viewIndex + 1} / ${(listSize / viewSize)?ceiling}"
                     onchange="<#if ajaxEnabled>ajaxUpdateAreas('${ajaxSelectUrl}')<#else>submitPagination(this, '${selectUrl}' + (this.value - 1))</#if>"/>
            </span>
          </li>
        </#if>
        <#-- 下一页 -->
        <li class="page-item<#if highIndex >= listSize> disabled</#if>">
          <a class="page-link" href="javascript:void(0)"
             <#if highIndex lt listSize>onclick="<#if ajaxEnabled>ajaxUpdateAreas('${ajaxNextUrl}')<#else>submitPagination(this, '${nextUrl}')</#if>"</#if>>
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none"><path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="9 6 15 12 9 18"/>
            </svg>
          </a>
        </li>
        <#-- 末页 -->
        <li class="page-item<#if highIndex >= listSize> disabled</#if>">
          <a class="page-link" href="javascript:void(0)"
             <#if highIndex lt listSize>onclick="<#if ajaxEnabled>ajaxUpdateAreas('${ajaxLastUrl}')<#else>submitPagination(this, '${lastUrl}')</#if>"</#if>>
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none"><path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="7 7 12 12 7 17"/><polyline points="13 7 18 12 13 17"/>
            </svg>
          </a>
        </li>
      </ul>
      <#-- 每页条数 -->
      <#if javaScriptEnabled>
        <div class="d-flex align-items-center gap-2">
          <select class="form-select form-select-sm w-auto" name="pageSize"
                  onchange="<#if ajaxEnabled>ajaxUpdateAreas('${ajaxSelectSizeUrl}')<#else>submitPagination(this, '${selectSizeUrl}')</#if>">
            <#list [20, 30, 50, 100, 200] as ps>
              <option<#if viewSize == ps> selected</#if> value="${ps}">${ps}</option>
            </#list>
          </select>
          <span class="text-muted">${paginateViewSizeLabel}</span>
        </div>
      </#if>
      <#-- 显示信息 -->
      <span class="text-muted">${commonDisplaying}</span>
    </div>
  </#if>
</#macro>

<#-- ============================================================
     renderFileField → .form-control (type="file")
     ============================================================ -->
<#macro renderFileField className alert name="" value="" size="" maxlength="" autocomplete="" tabindex="" disabled=false>
  <input type="file"
  <@renderClass "form-control " + className alert />
  <@renderDisabled disabled />
  <#if name?has_content> name="${name}"</#if>
  <#if value?has_content> value="${value}"</#if>
  <#if size?has_content> size="${size}"</#if>
  <#if maxlength?has_content> maxlength="${maxlength}"</#if>
  <#if autocomplete?has_content> autocomplete="off"</#if>
<#if tabindex?has_content> tabindex="${tabindex}"</#if>/><#rt/>
</#macro>

<#-- ============================================================
     renderPasswordField → .form-control (type="password")
     ============================================================ -->
<#macro renderPasswordField className alert name="" value="" size="" maxlength="" id="" autocomplete="" tabindex="" disabled=false>
  <input type="password"
  <@renderClass "form-control " + className alert />
  <@renderDisabled disabled />
  <#if name?has_content> name="${name}"</#if>
  <#if value?has_content> value="${value}"</#if>
  <#if size?has_content> size="${size}"</#if>
  <#if maxlength?has_content> maxlength="${maxlength}"</#if>
  <#if id?has_content> id="${id}"</#if>
  <#if autocomplete?has_content> autocomplete="off"</#if>
  <#if tabindex?has_content> tabindex="${tabindex}"</#if>
         required/><#rt/>
</#macro>

<#-- ============================================================
     renderImageField
     图片字段，补充 .img-fluid 响应式类
     ============================================================ -->
<#macro renderImageField action value="" description="" alternate="" style="" event="">
  <img
    <#if value?has_content> src="${value}"</#if>
    <#if description?has_content> title="${description}"</#if>
          alt="<#if alternate?has_content>${alternate}</#if>"
          class="img-fluid<#if style?has_content> ${style}</#if>"
  <#if event?has_content> ${event?html}="${action}"</#if>/>
</#macro>

<#-- ============================================================
     renderBanner
     横幅（左/中/右三栏）→ Tabler .row 替代 <table>
     ============================================================ -->
<#macro renderBanner style="" leftStyle="" rightStyle="" leftText="" text="" rightText="">
  <div class="row align-items-center w-100<#if style?has_content> ${style}</#if>">
    <#if leftText?has_content>
      <div class="col text-start<#if leftStyle?has_content> ${leftStyle}</#if>">${leftText}</div>
    </#if>
    <#if text?has_content>
      <div class="col text-center">${text}</div>
    </#if>
    <#if rightText?has_content>
      <div class="col text-end<#if rightStyle?has_content> ${rightStyle}</#if>">${rightText}</div>
    </#if>
  </div>
</#macro>

<#-- ============================================================
     renderContainerField
     通用容器 div，保持原有语义
     ============================================================ -->
<#macro renderContainerField id className>
  <div id="${id}" class="${className}"></div>
</#macro>

<#-- ============================================================
     renderFieldGroupOpen / renderFieldGroupClose
     字段分组 → Tabler .card 折叠面板
     ============================================================ -->
<#macro renderFieldGroupOpen collapsed collapsibleAreaId collapsible expandToolTip collapseToolTip style="" id="" title="">
  <#if style?has_content || id?has_content || title?has_content>
<div class="card mb-2<#if style?has_content> ${style}</#if>"<#if id?has_content> id="${id}"</#if>>
  <#if title?has_content || collapsible>
    <div class="card-header">
      <#if title?has_content><h4 class="card-title">${title}</h4></#if>
      <#if collapsible>
        <div class="card-options">
          <a href="#${collapsibleAreaId}" class="btn btn-sm btn-ghost-secondary card-options-collapse"
             data-bs-toggle="collapse"
             data-expand-tooltip="${expandToolTip}"
             data-collapse-tooltip="${collapseToolTip}"
             title="<#if collapsed>${expandToolTip}<#else>${collapseToolTip}</#if>">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="16" height="16" viewBox="0 0 24 24"
                 stroke-width="2" stroke="currentColor" fill="none">
              <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
              <polyline points="6 9 12 15 18 9"/>
            </svg>
          </a>
        </div>
      </#if>
    </div>
  </#if>
  <div id="${collapsibleAreaId}" class="collapse<#if !collapsed> show</#if>">
    <div class="card-body">
      </#if>
      </#macro>

      <#macro renderFieldGroupClose style="" id="" title="">
      <#if style?has_content || id?has_content || title?has_content>
    </div><!-- /.card-body -->
  </div><!-- /.collapse -->
</div><!-- /.card (fieldgroup) -->
  </#if>
</#macro>

<#-- ============================================================
     renderHyperlinkTitle
     列表表头链接 + 全选复选框
     ============================================================ -->
<#macro renderHyperlinkTitle name="selectAll" title="" showSelectAll="N">
  <#if title?has_content>${title}<br/></#if>
  <#if showSelectAll == "Y">
    <input type="checkbox" class="form-check-input selectAll" name="${name}" value="Y"/>
  </#if>
</#macro>

<#-- ============================================================
     renderSortField
     列头排序链接 → 保持 <a>，添加 Tabler 排序图标
     ============================================================ -->
<#macro renderSortField title linkUrl style="" ajaxEnabled="" tooltip="">
  <a class="<#if style?has_content>${style}<#else>table-sort</#if>"
     href="<#if ajaxEnabled?has_content && ajaxEnabled>javascript:ajaxUpdateAreas('${linkUrl}')<#else>${linkUrl}</#if>"
     <#if tooltip?has_content>title="${tooltip}"</#if>>
    ${title}
  </a>
</#macro>

<#macro formatBoundaryComment boundaryType widgetType widgetName><!-- ${boundaryType} ${widgetType} ${widgetName} --></#macro>

<#-- ============================================================
     renderTooltip → Tabler tooltip span
     ============================================================ -->
<#macro renderTooltip tooltip="" tooltipStyle="">
  <#if tooltip?has_content>
  <span class="<#if tooltipStyle?has_content>${tooltipStyle}<#else>badge bg-secondary ms-1</#if>"
        data-bs-toggle="tooltip" title="${tooltip}">?</span><#rt/>
  </#if>
</#macro>

<#-- ============================================================
     makeHiddenFormLinkForm / makeHiddenFormLinkAnchor
     隐藏表单 POST 链接，保持原有逻辑
     ============================================================ -->
<#macro makeHiddenFormLinkForm actionUrl name parameters targetWindow="" disabled=false>
  <form method="post" action="${actionUrl}"
        <#if targetWindow?has_content>target="${targetWindow}"</#if>
        onsubmit="javascript:submitFormDisableSubmits(this)"
        name="${name}" class="d-none">
    <#list parameters as parameter>
      <input name="${parameter.name}" value="${parameter.value?html}" type="hidden" <@renderDisabled disabled />/>
    </#list>
  </form>
</#macro>

<#macro makeHiddenFormLinkAnchor hiddenFormName description event="" action="" imgSrc="" confirmation="" linkStyle="">
  <a class="<#if linkStyle?has_content>${linkStyle}<#else>btn btn-sm btn-ghost-secondary</#if>"
     href="javascript:document.${hiddenFormName}.submit()"
  <#if action?has_content && event?has_content> ${event}="${action}"</#if>
  <#if confirmation?has_content> onclick="return confirm('${confirmation?js_string}')"</#if>>
  <#if imgSrc?has_content><img src="${imgSrc}" alt="" class="me-1"/></#if>
  ${description}
  </a>
</#macro>

<#-- ============================================================
     makeHyperlinkString
     通用超链接：
       uniqueItemName → Tabler Modal 弹窗触发
       否则            → 普通 <a> 链接，支持确认框
     ============================================================ -->
<#macro makeHyperlinkString hiddenFormName imgSrc imgTitle title alternate linkUrl description text="" linkStyle="" event="" action="" targetParameters="" targetWindow="" confirmation="" uniqueItemName="" height="" width="" id="">
  <#if uniqueItemName?has_content>
    <#local params = "{&quot;presentation&quot;: &quot;layer&quot;">
    <#if targetParameters?has_content && !targetParameters?is_hash>
      <#local parameterMap = targetParameters?eval>
      <#list parameterMap?keys as key>
        <#local params += ",&quot;${key}&quot;: &quot;${parameterMap[key]}&quot;">
      </#list>
    </#if>
    <#local params += "}">
    <a href="javascript:void(0);"
       id="${uniqueItemName}_link"
       class="<#if linkStyle?has_content>${linkStyle}</#if>"
       data-dialog-params="${params}"
       data-dialog-width="${width}"
       data-dialog-height="${height}"
       data-dialog-url="${linkUrl}"
       <#if text?has_content>data-dialog-title="${text}"</#if>>
      <#if description?has_content>${description?html}</#if>
    </a>
  <#else>
    <a class="<#if linkStyle?has_content && (description?has_content || imgSrc?has_content)>${linkStyle}</#if>"
       href="${linkUrl}"
       <#if targetWindow?has_content> target="${targetWindow}"</#if>
       <#if action?has_content && event?has_content> ${event}="${action}"</#if>
       <#if confirmation?has_content> data-confirm-message="${confirmation}"</#if>
       <#if id?has_content> id="${id}"</#if>
       <#if title?has_content> title="${title}"</#if>>
      <#if imgSrc?has_content><img src="${imgSrc}" alt="${alternate}" class="me-1"<#if imgTitle?has_content> title="${imgTitle}"</#if>/></#if>
      ${description?html}
    </a>
  </#if>
</#macro>
