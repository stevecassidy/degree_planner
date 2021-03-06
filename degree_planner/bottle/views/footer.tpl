</div> <!-- container -->
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="/static/js/bootstrap.min.js"></script>
    <script src="/static/js/select2.js"></script>
    <script>
        $(document).ready(function() { 	$("#degree").select2({ width: '300px' });
        								$("#major").select2({ width: '300px' });
        								$("#people").select2({ width: '300px' });
        								$("#planet").select2({ width: '300px' });
        								$("#computing").select2({ width: '300px' });
        								$("#business").select2({ width: '300px' });

        							
        							});
        

    </script>

    <script>
    	var mytarget, current_unit;
    	

    	$('#myModal').on('show.bs.modal', function (e) {
			  mytarget = e.relatedTarget;
			  current_unit = $.trim(mytarget.text);
			  console.log(mytarget.id);
			  $.ajax({
	            type: 'POST',
	            url: '/populate_modal',
	            data: JSON.stringify({ 'year_session' : mytarget.id }),
	            contentType: "application/json",
	            beforeSend: function () { $("#imgSpinner1").show(); },
		        // hides the loader after completion of request, whether successfull or failor.             
		        complete: function () { $("#imgSpinner1").hide(); },
	            //dataType: "json",
	            success: function(response) {
	                // Fill out the People Dropdown
	                $('#people').empty().append('<option value=""> Choose People Unit </option>');
	                for (var k in response['people_units']){
	                	var option = '<option value= "'+ response['people_units'][k] + '"> ' + response['people_units'][k] + '</option>';
	                	$('#people').append(option);
	                }
	                 // Fill out the Planet Dropdown
	                $('#planet').empty().append('<option value=""> Choose Planet Unit </option>');
	                for (var k in response['planet_units']){
	                	var option = '<option value= "'+ response['planet_units'][k] + '"> ' + response['planet_units'][k] + '</option>';
	                	$('#planet').append(option);
	                }

	                // Fill out COMP units
	                $('#computing').empty().append('<option value=""> Choose Computing Unit </option>');
	                for (var k in response['comp_units']){
	                	var option = '<option value= "'+ response['comp_units'][k] + '"> ' + response['comp_units'][k] + '</option>';
	                	$('#computing').append(option);
	                }

	                // Fill out BUS ECO units
	                $('#business').empty().append('<option value=""> Choose Business / Economics Unit </option>');
	                for (var k in response['bus_eco_units']){
	                	var option = '<option value= "'+ response['bus_eco_units'][k] + '"> ' + response['bus_eco_units'][k] + '</option>';
	                	$('#business').append(option);
	                }
	                
	            }
	        });


			});

			$(function() {
			// insert selected unit from modal into the table cell
			    $("button#submit").click(function(){
			    	$('.select_unit').each(function(){
			    		if ($(this).val())
			    			selected_unit = $(this).val();
			    			//alert($(this).val());
			    	});
			    	//alert(selected_unit);
			    	mytarget.text = selected_unit;

			    	// update the degree/major requirements
			    	$.ajax({
			            type: 'POST',
			            url: '/update_requirements',
			            data: JSON.stringify({ "selected_unit" : selected_unit, 'year_session' : mytarget.id, 'current_unit': current_unit  }),
			            contentType: "application/json",
			            beforeSend: function () { $("#imgSpinner2").show(); },
				        // hides the loader after completion of request, whether successfull or failor.             
				        complete: function () { $("#imgSpinner2").hide(); },
			            
			            //dataType: "json",
			            success: function(response) {
			            	current_unit = '';
			            	// Update the Requirements on the right pane
			            	if (Object.keys(response).length == 0)
			            		return true
			            	// Degree Requirement Units
			            	degree_req_units = response['updated_degree_req_units'];
			            	console.log(degree_req_units);
			            	if (degree_req_units.length >= 0)
			            		{
			            			$('#degree_req_units input + label').each(function(){
			            				// If req displayed cant be found in updated req, it means the req is satisfied
			            				if ($.inArray($.trim($(this).text()), degree_req_units) == -1) {
			            					$(this).removeClass('req_unsatisfied').addClass('req_satisfied');
			            					$(this).prev('input').prop('checked', true);
			            					$(this).attr('disabled', 'disabled');
			            				}
			            				else{
			            					$(this).removeClass('req_satisfied').addClass('req_unsatisfied');
			            					$(this).prev('input').prop('checked', false);
			            				}

			            			});
			            		}
			            		

			            	// General Degree Requirements
			            	gen_degree_req  = response['updated_gen_degree_req'];
			            	$('#gen_degree_req').text("");
			            	for (var k in gen_degree_req){
		            			if (gen_degree_req[k] == 0)
		            				{
					    			$('#gen_degree_req').append('<input type="checkbox" disabled="disabled"  checked> <label class="req_satisfied">' + k + ': 0  </label></input>  <br/>');
		            				}
					    		else
					    		{
					    			$('#gen_degree_req').append('<input type="checkbox">  <label class="req_unsatisfied">' + k + ' : ' + gen_degree_req[k] +  '</label></input>  <br/>');
					    		}
								
							
			            	}


			            	// Major Requirement Units
			            	major_req_units = response['updated_major_req_units']
			            	if  (major_req_units.length > 0)
			            		{
			            			console.log(major_req_units);
			            			$('#major_req_units input + label').each(function(){
			            				
			            				console.log($(this).text());
			            				if ($.inArray($.trim($(this).text()), major_req_units) == -1) {
			            					$(this).removeClass('req_unsatisfied').addClass('req_satisfied');
			            					$(this).prev('input').prop('checked', true);
			            					$(this).prev('input').prop('disabled', true);
			            				}
			            				else{
			            					$(this).removeClass('req_satisfied').addClass('req_unsatisfied');
			            					$(this).prev('input').prop('checked', false);
			            				}

			            			});
			            		}
			            	else
			            	{
			            		$('#major_req_units input:not(:checked) + label').each(function(){
			            			$(this).removeClass('req_unsatisfied').addClass('req_satisfied');
			            					$(this).prev('input').prop('checked', true);
			            					$(this).prev('input').prop('disabled', true);
			            				});

			            	}


			            }
			        });

			    	$('#myModal').modal('hide');
			    });
			  });
			
			// allow only one unit to be chosen from the modal popup
			$(document).ready(function(){
				$('.select_unit').change(function(){
					console.log($(this).siblings('select'));
					$(this).siblings('select').each(function(){
						$(this).val('');
					});
				});
			});
			
    </script>

    <script>
	    function populate_major(degree_code){

	        $.ajax({
	            type: 'POST',
	            url: '/populate_major',
	            data: JSON.stringify({ "degree_code" : degree_code }),
	            contentType: "application/json",
	            beforeSend: function () { $("#imgSpinner2").show(); },
		        // hides the loader after completion of request, whether successfull or failor.             
		        complete: function () { $("#imgSpinner2").hide(); },
	            
	            //dataType: "json",
	            success: function(response) {
	                // Fill out the Major Dropdown
	                $('#major').empty().append('<option value=""> Choose Major </option>');
	                for (var k in response['majors']){
	                	var option = '<option value= "'+ k + '"> ' + response['majors'][k] + '</option>';
	                	$('#major').append(option);
	                }
	                
	            }
	        });

	      }
	    $(document).ready(function(){
	    	$('#degree').change(function(){
	    		populate_major($(this).val());


	    	});

	    });

    </script>
    <br/><br/>
  </body>
</html>
