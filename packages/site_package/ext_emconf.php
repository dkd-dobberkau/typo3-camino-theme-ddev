<?php

$EM_CONF[$_EXTKEY] = [
    'title' => 'Site Package',
    'description' => 'Site package with DKD Green color scheme for TYPO3 Camino theme',
    'category' => 'templates',
    'author' => '',
    'author_email' => '',
    'state' => 'stable',
    'version' => '1.0.0',
    'constraints' => [
        'depends' => [
            'typo3' => '14.0.0-14.99.99',
            'theme_camino' => '14.1.0-14.99.99',
        ],
        'conflicts' => [],
        'suggests' => [],
    ],
];
