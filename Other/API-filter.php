<?php
/*
Plugin Name: API-filter
Plugin URI:  http://URI_Of_Page_Describing_Plugin_and_Updates
Description: API filters for AppBogado. To use in conjuction with WP REST API plugin.
Version:     0.0
Author:      Saul Ortigoza
Author URI:  http://URI_Of_The_Plugin_Author
License:     GPL2
License URI: https://www.gnu.org/licenses/gpl-2.0.html
Domain Path: /languages
Text Domain: my-toolset
*/

// from: https://css-tricks.com/using-the-wp-api-to-fetch-posts/
function qod_remove_extra_data( $data, $post, $context ) {
  // We only want to modify the 'view' context, for reading posts
  
  //  http://wordpress2.dev//wp-json/posts?context=view
  if($context == 'view')
  {
    // Here, we unset any data we don't want to see on the front end:
    unset( $data['author'] );
    unset( $data['status'] );
    unset( $data['comment_status'] );
    unset( $data['excerpt'] );
    unset( $data['featured_image'] );
    unset( $data['format'] );
    unset( $data['guid'] );
    unset( $data['menu_order'] );
    unset( $data['modified'] );
    unset( $data['modified_gmt'] );
    unset( $data['modified_tz'] );
    unset( $data['parent'] );
    unset( $data['ping_status'] );
    unset( $data['slug'] );
    unset( $data['sticky'] );
    unset( $data['meta'] );
    
    // continue unsetting whatever other fields you want

    return $data;
  }

  //  http://wordpress2.dev//wp-json/posts?context=search
  //  http://wordpress2.dev//wp-json/posts?context=index
  //  http://wordpress2.dev/wp-json/posts?context=search&filter[s]=Perro (Search by string)
  if($context == 'search' || $context == 'index')
  {
    // Here, we unset any data we don't want to see on the front end:
    unset( $data['author'] );
    unset( $data['status'] );
    unset( $data['comment_status'] );
    unset( $data['excerpt'] );
    unset( $data['featured_image'] );
    unset( $data['format'] );
    unset( $data['guid'] );
    unset( $data['menu_order'] );
    unset( $data['modified'] );
    unset( $data['modified_gmt'] );
    unset( $data['modified_tz'] );
    unset( $data['parent'] );
    unset( $data['ping_status'] );
    unset( $data['slug'] );
    unset( $data['sticky'] );
    unset( $data['meta'] );
    unset( $data['content'] );
    unset( $data['date'] );
    unset( $data['date_tz'] );
    
    // continue unsetting whatever other fields you want

    return $data;
  }

  return $data;

}

add_filter( 'json_prepare_post', 'qod_remove_extra_data', 12, 3 );

?>