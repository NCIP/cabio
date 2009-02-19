<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>caBIO Home Page</title>
<link rel="stylesheet" type="text/css" href="styleSheet.css" />
<link rel="stylesheet" type="text/css" href="css/jquery.suggest.css" />
<link rel="icon" type="image/x-ico" href="favicon.ico" />
<link rel="shortcut icon" type="image/x-icon" href="favicon.ico" />
<script src="script.js" type="text/javascript"></script>
<script src="js/jquery-1.2.3.min.js" type="text/javascript"></script>
<script src="js/jquery.bgiframe.js" type="text/javascript"></script>
<script src="js/jquery.dimensions.min.js" type="text/javascript"></script>
<script src="js/jquery.suggest.js" type="text/javascript"></script>
</head>
<body>
<table summary="" cellpadding="0" cellspacing="0" border="0"
	width="100%" height="100%">

	<%@ include file="include/header.inc"%>

	<tr>
		<td height="100%" align="center" valign="top">
		<table summary="" cellpadding="0" cellspacing="0" border="0"
			height="100%" width="871">

			<%@ include file="include/applicationHeader.inc"%>

			<tr>
				<td valign="top">
				<table summary="" cellpadding="0" cellspacing="0" border="0"
					height="100%" width="100%">
					<tr>
						<td height="20" class="mainMenu"><%@ include
							file="include/mainMenu.inc"%></td>
					</tr>

					<!--_____ main content begins _____-->
					<tr>
						<td valign="top"><!-- target of anchor to skip menus --> <a
							name="content" />
						<table summary="" cellpadding="0" cellspacing="0" border="0"
							class="contentPage" width="100%" height="100%">

							<tr>
								<td height="100%" width="100%"><!-- target of anchor to skip menus -->
								<a name="content" />

								<table summary="" cellpadding="0" cellspacing="0" border="0"
									height="100%" width="100%">
									<tr>
										<td width="70%"><!-- welcome begins -->
										<table summary="" cellpadding="0" cellspacing="0" border="0"
											height="100%" width="100%">
											<tr>
												<td class="welcomeTitle" height="20">WELCOME TO CABIO v<s:text name="build.version"/></td>
											</tr>
											<tr>
												<td class="welcomeContent" valign="top">The cancer
												Bioinformatics Infrastructure Objects (caBIO) model and
												architecture is a synthesis of software, vocabulary, and
												metadata models for cancer research. Each of the caBIO
												domain objects represents an entity found in biomedical
												research such as Gene, Chromosome, Nucleic Acid Sequence,
												SNP, Library, Clone, and Pathway. Given the dynamic nature
												of this information, the data in caBIO is updated on a
												monthly basis through a series of ETL (Extract, Transform,
												and Load) processes. <br>
												<br>
												References: <br>

												<ul>
													<li><a
														href="http://cabio.nci.nih.gov/NCICB/infrastructure/cacore_overview/caBIO">
													caBIO Overview</a> - High-level overview of caBIO</li>
													<li><a href="https://gforge.nci.nih.gov/projects/cabiodb/">
													caBIO GForge site</a> - Contains news, information,
													documents, defects, feedback, and reports</li>
													<li><a
														href="http://ncicb.nci.nih.gov/download/downloadcabio.jsp">
													caBIO Download site</a> - Contains download packages and
													release notes</li>
													<li><a
														href="http://gforge.nci.nih.gov/frs/?group_id=51&release_id=2695">caBIO
													<s:text name="build.version"/> Release Notes</a> - Latest release notes for caBIO</li>
													<li><a
														href="http://gforge.nci.nih.gov/frs/?group_id=51&release_id=2695">caBIO <s:text name="build.version"/>
													Data Refresh Release Notes</a> - Release notes describing
													the current data content of caBIO</li>
													<li><a href="docs">caBIO <s:text name="build.version"/> javadocs</a> - Java API
													documentation</li>
													<li><a href="http://gforge.nci.nih.gov/frs/?group_id=51&release_id=2695">caBIO <s:text name="build.version"/> Tech Guide</a> - Technical
													Guide</li>
												</ul>
												
												<br>
												<s:set name="url" scope="page" value="%{getText('build.svn.url')}"/>
												<%
												    String url = (String)pageContext.getAttribute("url");
												    if (url != null) {
											            if (url.contains("/tags/")) {
											                url = url.replaceFirst("^.*?/tags/", "");
											                url = url.replaceFirst("/.*?$", "");
											            }
											            else {
											                url = url.replaceFirst("/+$", "");
											                url = url.substring(url.lastIndexOf('/')+1);
											            }
												    }
												%>
                                                caBIO API <s:text name="build.version"/>, SVN:<a href="<s:text name="build.svn.url"/>"><%=url%></a>, Revision <s:text name="build.svn.revision"/>, Build <s:text name="build.date"/><br>
                                                
												</td>
											</tr>
										</table>
										<!-- welcome ends --></td>
										<td valign="top" width="30%"><!-- sidebar begins -->
										<table summary="" cellpadding="0" cellspacing="0" border="0"
											height="100%" width="100%">

											<!-- login/continue form begins -->
											<tr>
												<td valign="top">

												<table summary="" cellpadding="2" cellspacing="0" border="0"
													width="100%" class="sidebarSection">
													<tr>
														<td class="sidebarTitle" height="20">Search for Biological Entities</td>
													</tr>
													<tr>
														<td class="sidebarContent" align="center"><s:form
															method="post" action="ShowDynamicTree.action"
															name="continueForm" theme="simple">
															<s:submit cssClass="actionButton" value="Continue"
																theme="simple" />
														</s:form></td>
													</tr>
												</table>

												</td>
											</tr>
											<!-- login ends -->

											<!-- what's new begins -->
											<tr>
												<td valign="top">
												<table summary="" cellpadding="0" cellspacing="0" border="0"
													width="100%" class="sidebarSection">
													<tr>
														<td class="sidebarTitle" height="20">WHAT'S NEW</td>
													</tr>
													<tr>
														<td class="sidebarContent">
														<ul>
														    <li><a href="http://cagrid-portal.nci.nih.gov/web/guest/community">caBIO portlet</a></li>
														    <li>Pathway Interaction Database model and data</li>
														</ul>
														</td>
													</tr>
												</table>
												</td>
											</tr>
											<!-- what's new ends -->

											<!-- did you know? begins -->
											<tr>
												<td valign="top">
												<table summary="" cellpadding="0" cellspacing="0" border="0"
													width="100%" height="100%" class="sidebarSection">
													<tr>
														<td class="sidebarTitle" height="20">Text Search</td>
													</tr>
													<tr>
														<td class="sidebarContent" valign="top"><!-- freestyle search -->
														<form method=post action="searchService.jsp" name=form1>
														<table width="100%">
															<tr valign="top" align="center">
																<td colspan="2"><img src="images/smallsearchlogo.jpg"
																	name="caCORE Search API" border="0" align=middle></td>
															</tr>
															<tr>
																<td colspan="2" align=center nowrap><INPUT TYPE=TEXT SIZE=60
																	name="searchString" id="freestyleLM" value="">&nbsp;<a href="https://wiki.nci.nih.gov/display/ICR/Apache+Lucene+Query+Syntax+for+FreestyleLM+Search"><img src="images/help.png" alt="Lucene Query Syntax" name="Lucene Query Syntax" border="0" align=middle></a></td>
															</tr>
															<tr>
																<td width="60%" align="right"><INPUT TYPE=SUBMIT
																	NAME="search" VALUE="Search"> <INPUT TYPE=HIDDEN
																	NAME="FULL_TEXT_SEARCH" VALUE="FULL_TEXT_SEARCH" /></td>
																<td class="welcomeContent" align="right"><a href="search">more options ...</a></td>
															<tr>
														</table>
														</form>
														<script type="text/javascript">
														jQuery(function() {
															jQuery("#freestyleLM").suggest("suggest",{minchars:1});
														});
														</script>
														<!-- freestyle search --></td>
													</tr>
												</table>
												</td>
											</tr>
											<!-- did you know? ends -->

											<!-- spacer cell begins (keep for dynamic expanding) -->
											<tr>
												<td valign="top" height="100%">
												<table summary="" cellpadding="0" cellspacing="0" border="0"
													width="100%" height="100%" class="sidebarSection">
													<tr>
														<td class="sidebarContent" valign="top">&nbsp;</td>
													</tr>
												</table>
												</td>
											</tr>
											<!-- spacer cell ends -->

										</table>
										<!-- sidebar ends --></td>
									</tr>
								</table></td>
							</tr>
						</table></td>
					</tr>
					<!--_____ main content ends _____-->

					<tr>
						<td height="20" class="footerMenu"><!-- application ftr begins -->
						<%@ include file="include/applicationFooter.inc"%> <!-- application ftr ends -->

						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td><%@ include file="include/footer.inc"%></td>
	</tr>
</table>
</body>
</html>
